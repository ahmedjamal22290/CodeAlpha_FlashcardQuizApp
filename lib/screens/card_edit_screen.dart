import 'package:flutter/material.dart';

import '../models/flashcard.dart';

class CardEditScreen extends StatefulWidget {
  final Flashcard? card;

  const CardEditScreen({super.key, this.card});

  @override
  State<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends State<CardEditScreen> {
  late final TextEditingController _questionController;
  late final TextEditingController _answerController;
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.card != null;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.card?.question ?? '');
    _answerController = TextEditingController(text: widget.card?.answer ?? '');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final card = widget.card;
    final result = Flashcard(
      id: card?.id ?? generateId(),
      question: _questionController.text.trim(),
      answer: _answerController.text.trim(),
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Flashcard' : 'New Flashcard'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _questionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  hintText: 'What is on the front of the card?',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a question.'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _answerController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  hintText: 'What is the answer on the back?',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter an answer.'
                    : null,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Save Flashcard'),
                style: FilledButton.styleFrom(
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