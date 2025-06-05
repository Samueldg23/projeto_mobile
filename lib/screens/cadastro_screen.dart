import 'package:flutter/material.dart';
import '../model/aluno.dart';
import '../service/aluno_api.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _loading = false;
  String? _erro;

  Future<void> _cadastrar() async {
    setState(() {
      _loading = true;
      _erro = null;
    });

    final novoAluno = Aluno(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text,
    );

    final alunoCriado = await AlunoApi.cadastrar(novoAluno);

    setState(() => _loading = false);

    if (alunoCriado != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Cadastro realizado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // fecha dialog
                Navigator.pop(context); // volta ao login
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() => _erro = 'Falha no cadastro. Verifique os dados.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/logo_trabalho.png', width: 150),
                const SizedBox(height: 24),
                const Text(
                  'Cadastro de Aluno',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (_erro != null)
                  Text(_erro!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _loading ? null : _cadastrar,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Cadastrar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar para o login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
