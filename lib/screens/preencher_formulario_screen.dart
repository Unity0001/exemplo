import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agro/controllers/dados_controller.dart';
import '../widgets/custom_button.dart'; // Certifique-se de ter esse widget

class PreencherFormularioScreen extends StatefulWidget {
  const PreencherFormularioScreen({Key? key}) : super(key: key);

  @override
  State<PreencherFormularioScreen> createState() =>
      _PreencherFormularioScreenState();
}

class _PreencherFormularioScreenState extends State<PreencherFormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fazendaController = TextEditingController();
  final TextEditingController _plantacaoController = TextEditingController();
  bool _isLoading = false;

  void initState() {
    super.initState();

    _plantacaoController.addListener(() {
      final text = _plantacaoController.text;
      final transformed = text.replaceAll(' ', '|');

      if (text != transformed) {
        _plantacaoController.value = _plantacaoController.value.copyWith(
          text: transformed,
          selection: TextSelection.collapsed(offset: transformed.length),
        );
      }
    });
  }

  final _controller = DadosController();

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final nomeFazenda = _fazendaController.text.trim();
      final tiposPlantacao =
          _plantacaoController.text.split(',').map((e) => e.trim()).toList();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token não encontrado. Faça login novamente.'),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      final sucesso = await _controller.enviarFormulario(
        nome: nomeFazenda,
        tipoPlantacao: tiposPlantacao,
        token: token,
      );

      setState(() => _isLoading = false);

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formulário enviado com sucesso!')),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/menuScreen');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao enviar formulário.')),
        );
      }
    }
  }

  void _mostrarTermosDeUso() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Termos de Uso'),
            content: const SingleChildScrollView(
              child: Text(
                'Ao cadastrar a fazenda no aplicativo AgroSmart, você declara estar ciente e de acordo com os Termos de Uso e a Política de Privacidade. '
                'Os dados fornecidos serão utilizados exclusivamente para fins de análise, melhoria contínua dos nossos serviços, personalização da experiência do usuário '
                'e para garantir o funcionamento adequado da plataforma.\n\n'
                'Em conformidade com a Lei Geral de Proteção de Dados (LGPD), garantimos que todas as informações são armazenadas de forma segura, com uso de tecnologias de '
                'criptografia e boas práticas de segurança da informação.\n\n'
                'Nenhum dado será compartilhado com terceiros sem o seu consentimento expresso. '
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Fechar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
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
                  'Cadastro da Fazenda',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fazendaController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Fazenda',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe o nome da fazenda'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _plantacaoController,
                  decoration: const InputDecoration(
                    labelText: 'Tipos de Plantação (separados por pipe)',
                    hintText: 'Ex: Milho, Soja, Café',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe pelo menos uma plantação'
                              : null,
                ),

                const SizedBox(height: 30),
                CustomButton(
                  text: _isLoading ? 'Enviando...' : 'Enviar',
                  onPressed: _isLoading ? null : _enviarFormulario,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _mostrarTermosDeUso,
                  child: const Text.rich(
                    TextSpan(
                      text: 'Ao cadastrar, você aceita os ',
                      children: [
                        TextSpan(
                          text: 'Termos de Uso',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fazendaController.dispose();
    _plantacaoController.dispose();
    super.dispose();
  }
}
