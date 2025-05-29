import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:smart_agro/controllers/precossacas_controller.dart';
import 'dart:convert';

import '../__mocks__/main_mocks.mocks.dart';

void main() {
  group('PrecossacasController', () {
    late MockClient mockClient;
    late PrecossacasController controller;

    setUp(() {
      mockClient = MockClient();
      controller = PrecossacasController(client: mockClient);
    });

    test(
      'consultarPrecoSaca deve retornar resposta quando status 200',
      () async {
        final mockResponse = {
          'candidates': [
            {
              'content': {
                'parts': [
                  {'text': 'Preço atual da saca: R\$ 120,00'},
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

        final result = await controller.consultarPrecoSaca(
          'Qual o preço da soja?',
        );

        expect(result, equals('Preço atual da saca: R\$ 120,00'));
      },
    );

    test('consultarPrecoSaca deve retornar null em caso de erro', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Erro', 500));

      final result = await controller.consultarPrecoSaca(
        'Qual o preço da soja?',
      );

      expect(result, isNull);
    });
  });
}
