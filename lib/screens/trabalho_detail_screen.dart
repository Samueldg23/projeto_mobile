import 'package:flutter/material.dart';
import '../model/trabalho.dart';
import '../service/trabalho_api.dart';
import 'trabalho_form_screen.dart';

class TrabalhoDetailScreen extends StatelessWidget {
  final TrabalhoAcademico trabalho;

  const TrabalhoDetailScreen({super.key, required this.trabalho});

  Future<void> _excluir(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja excluir este trabalho?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final sucesso = await TrabalhoApi.deletar(trabalho.id!);
      if (sucesso && context.mounted) {
        Navigator.pop(context, true); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao excluir trabalho')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = DateTime.parse(trabalho.dataEntrega);
    final dias = data.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Trabalho'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final atualizado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrabalhoFormScreen(
                    alunoId: trabalho.alunoId,
                    trabalho: trabalho,
                  ),
                ),
              );
              if (atualizado == true && context.mounted) {
                Navigator.pop(context, true); 
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _excluir(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trabalho.titulo,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Disciplina: ${trabalho.disciplina}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Descrição:\n${trabalho.descricao}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              'Entrega: ${data.day}/${data.month}/${data.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Status: ',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                CircleAvatar(
                  radius: 6,
                  backgroundColor:
                      trabalho.status ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(trabalho.status ? 'Concluído' : 'Pendente'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              dias >= 0
                  ? 'Faltam $dias dias para a entrega'
                  : 'Entregue há ${-dias} dias',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
