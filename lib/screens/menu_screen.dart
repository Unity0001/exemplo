import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agro/route_observer/rota_observer.dart';
import 'package:smart_agro/widgets/app_bar.dart';
import 'package:smart_agro/widgets/custom_button.dart';
import 'package:smart_agro/widgets/green_gradient_background.dart';
import 'package:smart_agro/widgets/informacoes_tempo.dart';
import 'package:smart_agro/widgets/menu_hamburguer.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with RouteAware {
  String _email = '';
  String _primeiraLetra = '';

  @override
  void initState() {
    super.initState();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    rotaObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    rotaObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    debugPrint('🟢 Entrou na MenuScreen');
  }

  @override
  void didPop() {
    debugPrint('🔴 Saiu da MenuScreen');
  }

  @override
  void didPushNext() {
    debugPrint('➡️ Foi para outra tela a partir da MenuScreen');
  }

  @override
  void didPopNext() {
    debugPrint('⬅️ Voltou para a MenuScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: _primeiraLetra),
      drawer: DrawerWidget(nome: _email, email: ''),
      body: GreenGradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              InformacoesTempo(),
              const SizedBox(height: 5),
              CustomButton(
                text: 'Informações Plantio',
                icon: FontAwesomeIcons.seedling,
                onPressed: () {
                  Navigator.of(context).pushNamed('/plantacao');
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Preços das sacas',
                icon: FontAwesomeIcons.dollarSign,
                onPressed: () {
                  Navigator.of(context).pushNamed('/precosacaScreen');
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Previsão dos próximos dias',
                icon: FontAwesomeIcons.cloudRain,
                onPressed: () {
                  Navigator.of(context).pushNamed('/previsao-tempo');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
