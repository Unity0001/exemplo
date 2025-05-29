import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_login.dart';

class LoginController {
  final http.Client client;

  LoginController({required this.client});

  Future<bool> login(UserLogin user) async {
    final url = Uri.parse('http://52.91.106.224:4040/login');

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        return true;
      } else {
        print('Erro no login: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao conectar: $e');
      return false;
    }
  }
}
