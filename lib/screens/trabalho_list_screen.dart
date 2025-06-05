import 'package:flutter/material.dart';
import '../model/aluno.dart';
import '../model/trabalho.dart';
import '../service/trabalho_api.dart';
import '../database/trabalho_db.dart';
import 'trabalho_detail_screen.dart';
import 'trabalho_form_screen.dart';

class TrabalhoListScreen extends StatefulWidget {
  final Aluno aluno;

  const TrabalhoListScreen({super.key, required this.aluno});

  @override
  State<TrabalhoListScreen> createState() => _TrabalhoListScreenState();
}

class _TrabalhoListScreenState extends State<TrabalhoListScreen> {
  List<TrabalhoAcademico> _trabalhos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTrabalhos();
  }

  Future<void> _carregarTrabalhos() async {
    setState(() => _carregando = true);

    final trabalhosApi = await TrabalhoApi.buscarPorAluno(widget.aluno.id!);
    _trabalhos = trabalhosApi;

    // Salva no SQLite
    await TrabalhoDb.limpar();
    for (final t in _trabalhos) {
      await TrabalhoDb.inserir(t);
    }

    setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${widget.aluno.nome.split(" ").first}'),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TrabalhoFormScreen(alunoId: widget.aluno.id!),
            ),
          );
          if (resultado == true) _carregarTrabalhos();
        },
        child: const Icon(Icons.add),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _trabalhos.length,
              itemBuilder: (context, index) {
                final trabalho = _trabalhos[index];
                final diasRestantes = DateTime.parse(trabalho.dataEntrega)
                    .difference(DateTime.now())
                    .inDays;

                return ListTile(
                  onTap: () async {
                    final atualizadoOuExcluido = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TrabalhoDetailScreen(trabalho: trabalho),
                      ),
                    );
                    if (atualizadoOuExcluido == true) _carregarTrabalhos();
                  },
                  title: Text(trabalho.titulo),
                  subtitle: Text('${trabalho.disciplina} • ${trabalho.descricao}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 6,
                        backgroundColor:
                            trabalho.status ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        diasRestantes >= 0
                            ? 'Faltam $diasRestantes dias'
                            : 'Entregue há ${-diasRestantes} dias',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}


