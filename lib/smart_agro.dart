import 'package:flutter/material.dart';
import 'package:smart_agro/route_observer/rota_observer.dart';
import 'package:smart_agro/screens/configuracoes_screen.dart';
import 'package:smart_agro/screens/login_screen.dart';
import 'package:smart_agro/screens/nova_senha.dart';
import 'package:smart_agro/screens/precossacas_screen.dart';
import 'package:smart_agro/screens/preencher_formulario_screen.dart';
import 'package:smart_agro/screens/previsao_tempo.dart';
import 'package:smart_agro/screens/recuperar_conta.dart';
import 'package:smart_agro/screens/tela_plantacao.dart';
import 'package:smart_agro/screens/reset_senha.dart';
import 'package:smart_agro/screens/menu_screen.dart';
import 'package:smart_agro/screens/tela_localizacao.dart';
import 'package:smart_agro/screens/criar_conta.dart';


class SmartAgro extends StatelessWidget {
  const SmartAgro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [rotaObserver],
      title: 'Agro Smart | Bem-vindo(a)!',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Define a tela inicial do app
      routes: {
        '/': (context) => LoginScreen(), // Tela inicial (Login) 
        '/recuperarSenha':
            (context) => RecuperarConta(), // Tela de recuperar senha
        '/resetSenha': (context) => ResetSenha(), //Tela de Reset da senha
        '/criarConta': (context) => CriarConta(), // Tela criar conta
        '/menuScreen': (context) => MenuScreen(), //Tela Menu
        '/precosacaScreen': (context) => PrecosSacasScreen(),
        '/plantacao': (context) => AgroScreen(), // Tela de plantação
        '/telaLocalizacao': (context) => LocationScreen(), //Tela Localização.
        '/enviar-nova-senha': (context) => NovaSenhaPage(),
        '/previsao-tempo': (context) => TelaPrevisao(),
        '/configuracoes' : (context) => ConfiguracoesScreen(),
        '/preencher-formulario' : (context) => PreencherFormularioScreen(),
      },
    );
  }
}
