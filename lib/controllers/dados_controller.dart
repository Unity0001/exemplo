import 'dart:convert';
import 'package:http/http.dart' as http;

class DadosController {
  final String apiUrl = 'http://3.84.141.2:4040/preencher-dados';

  Future<bool> enviarFormulario({
    required String nome,
    required List<String> tipoPlantacao,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'tipo_plantacao': tipoPlantacao,
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }
}
