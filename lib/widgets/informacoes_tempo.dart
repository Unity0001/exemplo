import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agro/models/clima_model.dart';
import 'package:smart_agro/controllers/clima_controller.dart';
import 'package:smart_agro/utils/icon_map.dart';

class InformacoesTempo extends StatefulWidget {
  @override
  _InformacoesTempoState createState() => _InformacoesTempoState();
}

class _InformacoesTempoState extends State<InformacoesTempo> {
  late Future<ClimaModel> _climaFuturo;

  static const String _cidadeKey = 'cidade';
  late String _cidadeAtual;

  @override
  void initState() {
    super.initState();
    _carregarClima();
  }

  Future<void> _carregarClima() async {
    final prefs = await SharedPreferences.getInstance();
    _cidadeAtual = prefs.getString(_cidadeKey) ?? 'Moscow';

    print('🔍 Buscando clima para cidade: $_cidadeAtual');

    setState(() {
      _climaFuturo = ClimaController().buscarClimaAtual(cidade: _cidadeAtual);
    });
  }

  String _formatarDataAtual() {
    initializeDateFormatting('pt_BR', null);
    final agora = DateTime.now();
    final formatter = DateFormat('EEEE, d \'de\' MMMM \'de\' y', 'pt_BR');
    final dataFormatada = formatter.format(agora);
    return dataFormatada[0].toUpperCase() + dataFormatada.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClimaModel>(
      future: _climaFuturo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Erro ao carregar o clima 🌩️\n${snapshot.error}\nCidade buscada: $_cidadeAtual',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Text('Sem dados disponíveis.');
        }

        final clima = snapshot.data!;
        final screenWidth = MediaQuery.of(context).size.width;
        final icone = obterIcone(
          clima.icone,
          size: screenWidth * 0.4,
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icone,
            Text(
              clima.descricao[0].toUpperCase() + clima.descricao.substring(1),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              '${clima.temperatura.toStringAsFixed(0)} °C',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              _formatarDataAtual(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              'Umidade: ${clima.umidade.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              'Cidade: ${clima.cidade}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }
}
