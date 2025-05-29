import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecuperarContaController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();

  void dispose() {
    emailController.dispose();
    telefoneController.dispose();
  }

  Future<bool> recuperarConta() async {
    final email = emailController.text.trim();
    final telefone = telefoneController.text.trim();

    final Map<String, String> body = {
      'email': email,
      'telefone': telefone,
    };

    try {
      final response = await http.post(
        Uri.parse('http://3.84.141.2:4040/recuperar-senha'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
