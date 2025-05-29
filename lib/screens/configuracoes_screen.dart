import 'package:flutter/material.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  bool _notificacoesAtivas = true;
  bool _modoEscuro = false;

  @override
  Widget build(BuildContext context) {
    final themeAtual = _modoEscuro ? ThemeData.dark() : ThemeData.light();

    return Theme(
      data: themeAtual.copyWith(
        primaryColor: Colors.green,
        colorScheme: themeAtual.colorScheme.copyWith(primary: Colors.green),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Colors.green),
          trackColor: MaterialStateProperty.all(Colors.green.withOpacity(0.5)),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações do Sistema'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 10),
              const Text(
                'AgroSmart',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 3)],
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Receber notificações'),
                value: _notificacoesAtivas,
                onChanged: (value) {
                  setState(() => _notificacoesAtivas = value);
                },
                activeColor: Colors.green,
              ),
              SwitchListTile(
                title: const Text('Modo escuro'),
                value: _modoEscuro,
                onChanged: (value) {
                  setState(() => _modoEscuro = value);
                },
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
