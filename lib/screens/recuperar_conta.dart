import 'package:flutter/material.dart';
import '../controllers/recuperar_conta_controller.dart';
import '../widgets/custom_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RecuperarConta extends StatefulWidget {
  const RecuperarConta({Key? key}) : super(key: key);

  @override
  State<RecuperarConta> createState() => _RecuperarContaState();
}

class _RecuperarContaState extends State<RecuperarConta> {
  final _controller = RecuperarContaController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _recuperar() async {
    if (_controller.formKey.currentState!.validate()) {
      final resultado = await _controller.recuperarConta();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: resultado ? Text('SMS enviado') : Text('Erro ao enviar SMS'),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/enviar-nova-senha');
      });
    }
  }

  final telefoneMask = MaskTextInputFormatter(
    mask: '+## (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _controller.formKey,
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
                  'Recupere Sua Conta',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Informe seu e-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o e-mail';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo de telefone
                TextFormField(
                  controller: _controller.telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Informe seu telefone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o telefone';
                    }
                    return null;
                  },
                  inputFormatters: [telefoneMask],
                ),
                const SizedBox(height: 20),

                CustomButton(text: 'Recuperar Conta', onPressed: _recuperar),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
