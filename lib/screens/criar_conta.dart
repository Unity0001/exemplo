import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agro/controllers/login_controller.dart';
import 'package:smart_agro/models/user_login.dart';
import '../controllers/criar_conta_controller.dart';
import '../models/user_model.dart';
import '../widgets/custom_buttom_criar_conta.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CriarConta extends StatefulWidget {
  const CriarConta({Key? key}) : super(key: key);

  @override
  _CriarContaState createState() => _CriarContaState();
}

class _CriarContaState extends State<CriarConta> {
  final controller = CriarContaController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final telefoneMask = MaskTextInputFormatter(
    mask: '+## (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _submitForm() async {
    if (controller.formKey.currentState!.validate()) {
      final user = UserModel(
        nome: controller.nomeController.text,
        email: controller.emailController.text,
        senha: controller.senhaController.text,
        telefone: controller.telefoneController.text,
      );

      final resultado = await controller.enviarDados(user);

      if (resultado == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user.email);
        // Faz login automático após o cadastro
        final loginSuccess = await LoginController().login(
          UserLogin(email: user.email, senha: user.senha),
        );

        if (loginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro e login realizados com sucesso!'),
            ),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/preencher-formulario');
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro feito, mas erro ao fazer login.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar usuário.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
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
                  'Crie sua conta',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Nome
                TextFormField(
                  controller: controller.nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Digite seu nome'
                              : null,
                ),
                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Digite seu email';
                    if (!value.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Senha
                TextFormField(
                  controller: controller.senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.length < 6
                              ? 'A senha deve ter pelo menos 6 caracteres'
                              : null,
                ),
                const SizedBox(height: 20),

                // Confirmar Senha
                TextFormField(
                  controller: controller.confirmarSenhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirme sua senha',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value != controller.senhaController.text
                              ? 'As senhas não coincidem'
                              : null,
                ),
                const SizedBox(height: 20),

                // Telefone
                TextFormField(
                  controller: controller.telefoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Digite seu telefone'
                              : null,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [telefoneMask],
                ),

                const SizedBox(height: 20),

                // Termos de Uso
                // CheckboxListTile(
                //   title: const Text('Aceito os Termos de Uso'),
                //   value: _isChecked,
                //   onChanged: (bool? value) {
                //     setState(() {
                //       _isChecked = value ?? false;
                //     });
                //   },
                // ),
                const SizedBox(height: 20),

                // Botão
                CustomButtonCriarConta(
                  text: 'Criar Conta',
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
