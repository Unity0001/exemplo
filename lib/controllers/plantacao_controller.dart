import 'dart:convert';
import 'package:http/http.dart' as http;

class PlantacaoController {
  final http.Client client;

  PlantacaoController({required this.client});

  final String _apiKey = 'AIzaSyDVTJUPZBpyMIVG8pJtxnkDPZxLkHGnbBo';
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=';

  Future<String?> gerarConteudoGemini(String prompt) async {
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

  final String _apiKeyWheater = 'ab098a13f7061244602775ca9d99feff';
  final double _latitude = -25.4284;
  final double _longitude = -49.2733;

  Future<String> buscarAlertaClimatico() async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
      '?lat=$_latitude&lon=$_longitude&appid=$_apiKeyWheater&lang=pt_br',
    );

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.containsKey('alerts')) {
        final alertas = data['alerts'] as List;
        return alertas
            .map((alerta) {
              final event = alerta['event'];
              final descricao = alerta['description'];
              return '🚨 $event: $descricao';
            })
            .join('\n\n');
      } else {
        return '✅ Sem alertas climáticos no momento.';
      }
    } else {
      return 'Erro ao buscar informações do clima.';
    }
  }
}
