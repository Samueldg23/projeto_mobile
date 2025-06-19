import 'package:flutter/material.dart';
import '../../model/universitario.dart';
import '../../model/trabalho.dart';
import '../../service/trabalho_api.dart';
import '../../database/trabalho_db.dart';
import 'api_detalhes_screen.dart';

class ApiScreen extends StatefulWidget {
  final Universitario universitario;

  const ApiScreen({super.key, required this.universitario});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List<TrabalhoAcademico> _trabalhos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTrabalhos();
  }

  Future<void> _carregarTrabalhos() async {
  setState(() => _carregando = true);

  final trabalhosApi = await TrabalhoApi.buscarPorUniversitario(widget.universitario.id!);

  if (!mounted) return;

  _trabalhos = trabalhosApi;

  await TrabalhoDb.limpar();
  for (final t in _trabalhos) {
    await TrabalhoDb.inserir(t);
  }

  if (!mounted) return;

  setState(() => _carregando = false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.universitario.nome,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              widget.universitario.email,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
      body:
          _carregando
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _trabalhos.length,
                itemBuilder: (context, index) {
                  final trabalho = _trabalhos[index];
                  final diasRestantes =
                      DateTime.parse(
                        trabalho.dataEntrega,
                      ).difference(DateTime.now()).inDays;

                  return ListTile(
                    onTap: () async {
                      final atualizadoOuExcluido = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApiDetalhesScreen(trabalho: trabalho),
                        ),
                      );
                      if (atualizadoOuExcluido == true) _carregarTrabalhos();
                    },
                    title: Text(trabalho.titulo),
                    subtitle: Text(
                      '${trabalho.disciplina} • ${trabalho.descricao}',
                    ),
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
