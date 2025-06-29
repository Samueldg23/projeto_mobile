import 'package:flutter/material.dart';
import '../../model/trabalho.dart';
import '../../service/trabalho_api.dart';

class ApiDetalhesScreen extends StatefulWidget {
  final TrabalhoAcademico trabalho;

  const ApiDetalhesScreen({super.key, required this.trabalho});

  @override
  State<ApiDetalhesScreen> createState() => _ApiDetalhesScreenState();
}
//tela de edição e delete de trablhos vindos da api
class _ApiDetalhesScreenState extends State<ApiDetalhesScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _disciplinaController;
  late TextEditingController _dataEntregaController;
  bool _status = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.trabalho.titulo);
    _descricaoController = TextEditingController(
      text: widget.trabalho.descricao,
    );
    _disciplinaController = TextEditingController(
      text: widget.trabalho.disciplina,
    );
    _dataEntregaController = TextEditingController(
      text: widget.trabalho.dataEntrega,
    );
    _status = widget.trabalho.status;
  }

  Future<void> _editarTrabalho() async {
    final atualizado = TrabalhoAcademico(
      id: widget.trabalho.id,
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      disciplina: _disciplinaController.text.trim(),
      dataEntrega: _dataEntregaController.text.trim(),
      status: _status,
      universitarioId: widget.trabalho.universitarioId,
    );

    try {
      await TrabalhoApi.atualizar(atualizado);
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar trabalho')),
        );
      }
    }
  }
//funções que trabalham com valores futuros por causa do await e async
  Future<void> _excluirTrabalho() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
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

    if (confirmar == true) {
      try {
        await TrabalhoApi.excluir(widget.trabalho.id!);
        if (context.mounted) Navigator.pop(context, true);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao excluir trabalho')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes do Trabalho',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _excluirTrabalho,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _disciplinaController,
              decoration: const InputDecoration(labelText: 'Disciplina'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dataEntregaController,
              decoration: const InputDecoration(
                labelText: 'Data de entrega (yyyy-MM-dd)',
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Status: Concluído'),
              value: _status,
              onChanged: (val) {
                setState(() {
                  _status = val;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _editarTrabalho,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Salvar', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
