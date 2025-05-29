import 'package:flutter_test/flutter_test.dart';
import 'package:smart_agro/controllers/clima_controller.dart';
import 'package:smart_agro/models/clima_model.dart';

void main() {
  group('ClimaController Integration Test (Real API Call)', () {
    late ClimaController climaController;

    setUp(() {
      climaController = ClimaController();
    });

    test('deve retornar um ClimaModel para uma cidade válida', () async {
      const String cidadeTeste = 'Curitiba';

      final ClimaModel clima = await climaController.buscarClimaAtual(
        cidade: cidadeTeste,
      );

      expect(clima, isA<ClimaModel>());
      expect(clima.cidade, isNotEmpty);
      expect(clima.temperatura, isNotNull);
      expect(clima.descricao, isNotEmpty);
      expect(clima.icone, isNotEmpty);
    });

    test(
      'deve lançar uma exceção para uma cidade inválida/não existente',
      () async {
        const String cidadeInvalida = 'CidadeQueNaoExisteNoMundo';

        expect(
          () => climaController.buscarClimaAtual(cidade: cidadeInvalida),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
