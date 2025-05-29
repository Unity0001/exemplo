import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class ResetSenha extends StatelessWidget {
  const ResetSenha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 150),
              const SizedBox(height: 20),
              const Text(
                'AgroSmart',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 3)],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reset Sua Senha',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Informe Sua Nova Senha',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(label: 'Confirme a Senha', obscureText: true),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              CustomButton(text: 'Resetar', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
