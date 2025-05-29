import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agro/controllers/previsao_controller.dart';
import 'package:smart_agro/models/previsao_dia.dart';
import 'package:smart_agro/widgets/app_bar.dart';
import 'package:smart_agro/widgets/menu_hamburguer.dart';
import 'package:smart_agro/widgets/green_gradient_background.dart';

class TelaPrevisao extends StatefulWidget {
  @override
  _TelaPrevisaoState createState() => _TelaPrevisaoState();
}

class _TelaPrevisaoState extends State<TelaPrevisao> {
  final _controller = TextEditingController();
  List<PrevisaoDia> previsoes = [];
  String _email = '';
  String _primeiraLetra = '';
  bool _carregando = false;

  Future<void> buscarPrevisao() async {
    final cityName = _controller.text.trim();
    if (cityName.isEmpty) return;

    setState(() {
      _carregando = true;
    });

    final controller = PrevisaoController();
    final cityKey = await controller.buscarCityKey(cityName);

    if (cityKey != null) {
      final dados = await controller.buscarPrevisao5Dias(cityKey);
      setState(() {
        previsoes = dados;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cidade não encontrada', style: GoogleFonts.quicksand())));
    }

    setState(() {
      _carregando = false;
    });
  }

  Future<void> _carregarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final emailSalvo = prefs.getString('email') ?? '';

    setState(() {
      _email = emailSalvo;
      _primeiraLetra = emailSalvo.isNotEmpty ? emailSalvo[0].toUpperCase() : '';
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null).then((_) {
      Intl.defaultLocale = 'pt_BR';
      _controller.text = 'São João da Boa Vista';
      buscarPrevisao(); 
    });
    _carregarEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: _primeiraLetra),
      drawer: DrawerWidget(nome: _email, email: ''),
      body: GreenGradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Digite o nome da cidade',
                        hintStyle: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        border: const OutlineInputBorder(),
                      ),
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w900),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: buscarPrevisao,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : previsoes.isEmpty
                        ? Center(child: Text('Nenhuma previsão encontrada.', style: GoogleFonts.quicksand()))
                        : ListView.builder(
                            itemCount: previsoes.length,
                            itemBuilder: (context, index) {
                              final dia = previsoes[index];
                              return Card(
                                child: ListTile(
                                  leading: Image.asset(
                                    'images/${dia.icone}.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  title: Text(
                                    '${DateFormat('EEEE', 'pt_BR').format(dia.data)[0].toUpperCase()}${DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(dia.data).substring(1)} - ${dia.descricao}',
                                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    'Máx: ${dia.temperaturaMax}°C / Mín: ${dia.temperaturaMin}°C',
                                    style: GoogleFonts.quicksand(),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
