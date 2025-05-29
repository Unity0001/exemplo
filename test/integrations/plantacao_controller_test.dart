import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:smart_agro/controllers/plantacao_controller.dart';
import 'dart:convert';

import '../__mocks__/main_mocks.mocks.dart';

void main() {
  group('PlantacaoController', () {
    late MockClient mockClient;
    late PlantacaoController controller;

    setUp(() {
      mockClient = MockClient();
      controller = PlantacaoController(client: mockClient);
    });

    test(
      'gerarConteudoGemini deve retornar resposta quando status 200',
      () async {
        final mockResponse = {
          'candidates': [
            {
              'content': {
                'parts': [
                  {'text': 'Resposta gerada'},
                ],
              },
            },
          ],
        };

        when(
          mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

        final result = await controller.gerarConteudoGemini('Teste prompt');

        expect(result, equals('Resposta gerada'));
      },
    );

    test('gerarConteudoGemini deve retornar null em erro', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Erro', 500));

      final result = await controller.gerarConteudoGemini('Teste prompt');

      expect(result, isNull);
    });

    test(
      'buscarAlertaClimatico deve retornar sem alertas se não houver',
      () async {
        final mockResponse = {
          'coord': {'lon': -49.2733, 'lat': -25.4284},
          'weather': [],
          'base': 'stations',
          'main': {},
        };

        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

        final result = await controller.buscarAlertaClimatico();

        expect(result, equals('✅ Sem alertas climáticos no momento.'));
      },
    );

    test(
      'buscarAlertaClimatico deve retornar mensagem de erro se falhar',
      () async {
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Erro', 500));

        final result = await controller.buscarAlertaClimatico();

        expect(result, equals('Erro ao buscar informações do clima.'));
      },
    );

    test('buscarAlertaClimatico deve retornar alerta se presente', () async {
      final mockResponse = {
        'alerts': [
          {
            'event': 'Tempestade',
            'description': 'Chuva intensa e ventos fortes.',
          },
        ],
      };

      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await controller.buscarAlertaClimatico();

      expect(result, contains('🚨 Tempestade: Chuva intensa e ventos fortes.'));
    });
  });
}
