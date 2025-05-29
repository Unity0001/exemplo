import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agro/controllers/precossacas_controller.dart';
import 'package:smart_agro/widgets/app_bar.dart';
import 'package:smart_agro/widgets/menu_hamburguer.dart';
import 'package:smart_agro/widgets/green_gradient_background.dart';

class PrecosSacasScreen extends StatefulWidget {
  const PrecosSacasScreen({super.key});

  @override
  _PrecosSacasScreenState createState() => _PrecosSacasScreenState();
}

class _PrecosSacasScreenState extends State<PrecosSacasScreen> {
  final controller = PrecossacasController();
  String precoSacas = 'Carregando...';
  String _email = '';
  String _primeiraLetra = '';

  @override
  void initState() {
    super.initState();
    carregarInformacoes();
    _carregarEmail();
  }

  Future<void> _carregarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final emailSalvo = prefs.getString('email') ?? '';

    setState(() {
      _email = emailSalvo;
      _primeiraLetra = emailSalvo.isNotEmpty ? emailSalvo[0].toUpperCase() : '';
    });
  }

  void carregarInformacoes() async {
    final plantio = await controller.consultarPrecoSaca(
      'Me diga diretamente em tópicos as cotações dos preços das sacas de milho, café, soja, arroz, feijão, cana de açuçar, sendo direto e objetivo. Apenas falando os preços pela região do brasil. Sem colocar textos avulsos. Me forneça a cotação em dólar e real.',
    );

    setState(() {
      precoSacas = plantio ?? 'Erro ao buscar informação.';
    });
  }

  bool temMarkdown(String texto) {
    return texto.contains('*') ||
        texto.contains('- ') ||
        texto.contains('#') ||
        texto.contains('\n');
  }

  Widget renderTexto(String texto, BuildContext context) {
    return temMarkdown(texto)
        ? MarkdownBody(
            data: texto,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: GoogleFonts.quicksand(color: Colors.white),
              listBullet: GoogleFonts.quicksand(color: Colors.white),
            ),
          )
        : Text(texto, style: GoogleFonts.quicksand(color: Colors.white));
  }

  Widget renderConteudoOuLoading(String texto, BuildContext context) {
    if (texto == 'Carregando...' || texto == 'Carrregando...') {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } else {
      return temMarkdown(texto)
          ? MarkdownBody(
              data: texto,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: GoogleFonts.quicksand(color: Colors.white),
                listBullet: GoogleFonts.quicksand(color: Colors.white),
              ),
            )
          : Text(texto, style: GoogleFonts.quicksand(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: _primeiraLetra),
      drawer: DrawerWidget(nome: _email, email: ''),
      body: GreenGradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.attach_money, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Cotações de Sacas:',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      renderConteudoOuLoading(precoSacas, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
