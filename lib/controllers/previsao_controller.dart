import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_agro/models/previsao_dia.dart';

class PrevisaoController {
  final String _accuWeatherApiKey = 'uQw1g53Te5WAooFGMmcyXJ3zC7lZoZs6';

  Future<String?> buscarCityKey(String nomeCidade) async {
    final url = Uri.parse(
      'http://dataservice.accuweather.com/locations/v1/cities/search'
      '?apikey=$_accuWeatherApiKey&q=$nomeCidade&language=pt-br',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      if (data.isNotEmpty) {
        return data[0]['Key'];
      }
    }
    print('Erro ao buscar cityKey: ${response.body}');
    return null;
  }

  Future<List<PrevisaoDia>> buscarPrevisao5Dias(String cityKey) async {
    final url = Uri.parse(
      'http://dataservice.accuweather.com/forecasts/v1/daily/5day/$cityKey'
      '?apikey=$_accuWeatherApiKey&language=pt-br&details=true&metric=true',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List dias = data['DailyForecasts'];

      return dias.map<PrevisaoDia>((dia) {
        return PrevisaoDia(
          descricao: dia['Day']['IconPhrase'],
          icone: dia['Day']['Icon'].toString(),
          temperaturaMin: dia['Temperature']['Minimum']['Value'].toDouble(),
          temperaturaMax: dia['Temperature']['Maximum']['Value'].toDouble(),
          data: DateTime.parse(dia['Date']),
          
          
        );
      }).toList();
    } else {
      throw Exception('Erro ao buscar previsão');
    }
  }
}
