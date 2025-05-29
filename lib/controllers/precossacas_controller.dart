import 'dart:convert';
import 'package:http/http.dart' as http;

class PrecossacasController {
  final http.Client client;

  PrecossacasController({required this.client});

  final String _apiKey = 'AIzaSyDVTJUPZBpyMIVG8pJtxnkDPZxLkHGnbBo';
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=';

  Future<String?> consultarPrecoSaca(String prompt) async {
    final uri = Uri.parse('$_baseUrl$_apiKey');

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    });

    final response = await client.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final resposta = data['candidates']?[0]['content']['parts'][0]['text'];
      return resposta;
    } else {
      print('Erro ao gerar conteúdo: ${response.statusCode}');
      print('Resposta: ${response.body}');
      return null;
    }
  }
}
