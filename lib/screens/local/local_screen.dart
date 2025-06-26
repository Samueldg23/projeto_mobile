import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trabalhos_academicos/database/trabalho_db.dart';
import 'package:trabalhos_academicos/model/trabalho.dart';
import 'package:trabalhos_academicos/service/trabalho_api.dart';
import 'local_detalhes_screen.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  List<TrabalhoAcademico> _trabalhos = [];
  String _nomeUsuario = '';
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosLocais();
  }

  Future<void> _carregarDadosLocais() async {
    setState(() => _carregando = true);

    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('universitarioId') ?? 0;
    _nomeUsuario = prefs.getString('universitarioNome') ?? 'Usuário';

    _trabalhos = await TrabalhoDb.listarPorUniversitario(id);

    setState(() => _carregando = false);
  }

  Future<void> _sincronizarComApi() async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getInt('universitarioId');
  if (id == null) return;

  setState(() => _carregando = true);

  final novosTrabalhos = await TrabalhoApi.buscarPorUniversitario(id);

  await TrabalhoDb.limpar();
  for (final t in novosTrabalhos) {
    await TrabalhoDb.inserir(t);
  }

  _trabalhos = await TrabalhoDb.listarPorUniversitario(id);

  setState(() => _carregando = false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline: $_nomeUsuario', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.white),
            tooltip: 'Sincronizar com API',
            onPressed: _sincronizarComApi,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: 'Limpar dados locais',
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja apagar todos os dados salvos localmente?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Apagar'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await TrabalhoDb.limpar();
          setState(() => _trabalhos.clear());
        }
      },
    ),
  ],
),

      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _trabalhos.isEmpty
              ? const Center(child: Text('Nenhum trabalho salvo localmente.'))
              : ListView.builder(
                  itemCount: _trabalhos.length,
                  itemBuilder: (context, index) {
                    final trabalho = _trabalhos[index];
                    final diasRestantes = DateTime.parse(trabalho.dataEntrega)
                        .difference(DateTime.now())
                        .inDays;

                    return ListTile(
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LocalDetalhesScreen(trabalho: trabalho),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
