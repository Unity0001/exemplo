import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_button.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({Key? key}) : super(key: key);

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _enviarNovaSenha() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final body = {
        'email': _emailController.text.trim(),
        'token': _tokenController.text.trim(),
        'novaSenha': _senhaController.text.trim(),
      };

      try {
        final response = await http.post(
          Uri.parse('http://3.84.141.2:4040/enviar-nova-senha'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Senha redefinida com sucesso'),
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/');
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Erro ao redefinir a senha'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro de conexão: $e')));
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
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
                  'Redefinir Senha',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Informe seu e-mail, token enviado por SMS e a nova senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe o e-mail'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    labelText: 'Token',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe o token'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nova senha',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.length < 6
                              ? 'Senha muito curta'
                              : null,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: _isLoading ? 'Enviando...' : 'Confirmar',
                  onPressed: _isLoading ? null : _enviarNovaSenha,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text(
                    'Voltar ao login',
                    style: TextStyle(color: Colors.green),
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
