import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/aluno_api.dart';
import 'trabalho_list_screen.dart'; // Tela principal após login
import 'cadastro_screen.dart'; // Tela de cadastro (iremos criar depois)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _loading = false;
  String? _erro;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _erro = null;
    });

    final aluno = await AlunoApi.login(
      _emailController.text,
      _senhaController.text,
    );

    setState(() => _loading = false);

    if (aluno != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('alunoId', aluno.id!);
      await prefs.setString('alunoNome', aluno.nome);
      await prefs.setString('alunoEmail', aluno.email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TrabalhoListScreen(aluno: aluno)),
      );
    } else {
      setState(() => _erro = 'Email ou senha inválidos.');
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
                  'Gerenciador de Trabalhos UniSales',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 24),
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
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Entrar', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CadastroScreen()),
                    );
                  },
                  child: const Text('Não tem conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
