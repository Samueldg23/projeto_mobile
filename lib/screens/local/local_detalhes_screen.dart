import 'package:flutter/material.dart';
import 'package:trabalhos_academicos/model/trabalho.dart';

class LocalDetalhesScreen extends StatelessWidget {
  final TrabalhoAcademico trabalho;

  const LocalDetalhesScreen({super.key, required this.trabalho});

  @override
  Widget build(BuildContext context) {
    final data = DateTime.parse(trabalho.dataEntrega);
    final dias = data.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes (Local)'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trabalho.titulo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Disciplina: ${trabalho.disciplina}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Descrição:\n${trabalho.descricao}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Entrega: ${data.day}/${data.month}/${data.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                CircleAvatar(
                  radius: 6,
                  backgroundColor: trabalho.status ? Colors.green : Colors.red,
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
