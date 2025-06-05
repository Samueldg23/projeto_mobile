import 'package:flutter/material.dart';
import '../model/trabalho.dart';
import '../service/trabalho_api.dart';

class TrabalhoFormScreen extends StatefulWidget {
  final int alunoId;
  final TrabalhoAcademico? trabalho;

  const TrabalhoFormScreen({super.key, required this.alunoId, this.trabalho});

  @override
  State<TrabalhoFormScreen> createState() => _TrabalhoFormScreenState();
}

class _TrabalhoFormScreenState extends State<TrabalhoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _disciplinaController = TextEditingController();
  DateTime _dataEntrega = DateTime.now();
  bool _status = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.trabalho != null) {
      _tituloController.text = widget.trabalho!.titulo;
      _descricaoController.text = widget.trabalho!.descricao;
      _disciplinaController.text = widget.trabalho!.disciplina;
      _dataEntrega = DateTime.parse(widget.trabalho!.dataEntrega);
      _status = widget.trabalho!.status;
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final trabalho = TrabalhoAcademico(
      id: widget.trabalho?.id,
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      disciplina: _disciplinaController.text.trim(),
      dataEntrega: _dataEntrega.toIso8601String().split('T').first,
      status: _status,
      alunoId: widget.alunoId,
    );

    final sucesso = widget.trabalho == null
        ? await TrabalhoApi.criar(trabalho)
        : await TrabalhoApi.atualizar(trabalho);

    setState(() => _salvando = false);

    if (sucesso) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar trabalho')),
      );
    }
  }

  Future<void> _selecionarDataEntrega() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataEntrega,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (data != null) setState(() => _dataEntrega = data);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.trabalho != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Trabalho' : 'Novo Trabalho'),
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
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _salvando ? null : _salvar,
                child: _salvando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
