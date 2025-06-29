import 'package:flutter/material.dart';
import '../../model/trabalho.dart';
import '../../service/trabalho_api.dart';

class NovoTrabalhoScreen extends StatefulWidget {
  final int universitarioId;

  const NovoTrabalhoScreen({super.key, required this.universitarioId});

  @override
  State<NovoTrabalhoScreen> createState() => _NovoTrabalhoScreenState();
}
//tela de cadastro de novos trabalhos
class _NovoTrabalhoScreenState extends State<NovoTrabalhoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _disciplinaController = TextEditingController();
  DateTime _dataEntrega = DateTime.now();
  bool _status = false;
  bool _salvando = false;

  Future<void> _selecionarDataEntrega() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataEntrega,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (data != null) setState(() => _dataEntrega = data);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final trabalho = TrabalhoAcademico(
      id: null,
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      disciplina: _disciplinaController.text.trim(),
      dataEntrega: _dataEntrega.toIso8601String().split('T').first,
      status: _status,
      universitarioId: widget.universitarioId,
    );

    try {
      await TrabalhoApi.cadastrar(trabalho);
      if (context.mounted) Navigator.pop(context, true);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar trabalho')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Trabalho', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v!.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (v) => v!.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _disciplinaController,
                decoration: const InputDecoration(labelText: 'Disciplina'),
                validator: (v) => v!.isEmpty ? 'Informe a disciplina' : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  'Entrega: ${_dataEntrega.day}/${_dataEntrega.month}/${_dataEntrega.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selecionarDataEntrega,
              ),
              CheckboxListTile(
                title: const Text('Concluído'),
                value: _status,
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _salvando ? null : _salvar,
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
      ),
    );
  }
}
