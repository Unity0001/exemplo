import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:smart_agro/controllers/criar_conta_controller.dart';

import 'package:smart_agro/models/user_model.dart';

import '../__mocks__/main_mocks.mocks.dart';

void main() {
  group('CriarContaController', () {
    late CriarContaController controller;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      controller = CriarContaController(client: mockClient);
    });

    tearDown(() {
      controller.dispose();
    });

    final user = UserModel(
      nome: 'Teste',
      email: 'teste@exemplo.com',
      senha: '123456',
      telefone: '123456789',
    );
    test('deve retornar true quando a resposta for 200', () async {
      when(
        mockClient.post(
          Uri.parse('http://52.91.106.224:4040/create'),
          headers: {'Content-Type': 'application/json'},
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('{}', 200));

      final result = await controller.enviarDados(user);
      expect(result, isTrue);
    });

    test(
      'deve retornar false quando a resposta for diferente de 200',
      () async {
        when(
          mockClient.post(
            Uri.parse('http://52.91.106.224:4040/create'),
            headers: {'Content-Type': 'application/json'},
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('{}', 400));

        final result = await controller.enviarDados(user);
        expect(result, isFalse);
      },
    );

    test('deve retornar false quando lançar uma exceção', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenThrow(Exception('Erro de rede'));

      final result = await controller.enviarDados(user);
      expect(result, isFalse);
    });
  });
}
