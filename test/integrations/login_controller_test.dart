import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agro/controllers/login_controller.dart';
import 'package:smart_agro/models/user_login.dart';

import '../__mocks__/main_mocks.mocks.dart';

void main() {
  group('LoginController', () {
    late MockClient mockClient;
    late LoginController controller;

    setUp(() {
      mockClient = MockClient();
      controller = LoginController(client: mockClient);
    });

    final user = UserLogin(email: 'test@email.com', senha: '123456');

    test('deve retornar true e salvar o token no login bem-sucedido', () async {
      SharedPreferences.setMockInitialValues({});

      when(
        mockClient.post(
          Uri.parse('http://52.91.106.224:4040/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(jsonEncode({'token': 'fake-token'}), 200),
      );

      final result = await controller.login(user);

      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('jwt_token');

      expect(result, isTrue);
      expect(savedToken, equals('fake-token'));
    });

    test('deve retornar false se a API retornar erro', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Erro', 401));

      final result = await controller.login(user);
      expect(result, isFalse);
    });

    test('deve retornar false se lançar exceção', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenThrow(Exception('Erro de rede'));

      final result = await controller.login(user);
      expect(result, isFalse);
    });
  });
}
