import 'package:flutter/material.dart';

import '../models/flashcard.dart';
import '../services/storage_service.dart';
import 'card_edit_screen.dart';
import 'study_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Flashcard> _cards = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await StorageService.load();
    setState(() {
      _cards = cards;
      _loading = false;
    });
  }

  Future<void> _persist() async {
    await StorageService.save(_cards);
  }

  Future<void> _addCard() async {
    final result = await Navigator.of(context).push<Flashcard>(
      MaterialPageRoute(builder: (_) => const CardEditScreen()),
    );
    if (result != null) {
      setState(() => _cards.add(result));
      await _persist();
    }
  }

  Future<void> _editCard(Flashcard card) async {
    final result = await Navigator.of(context).push<Flashcard>(
      MaterialPageRoute(builder: (_) => CardEditScreen(card: card)),
    );
    if (result != null) {
      setState(() {
        final index = _cards.indexWhere((c) => c.id == result.id);
        if (index != -1) _cards[index] = result;
      });
      await _persist();
    }
  }

  Future<void> _deleteCard(Flashcard card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete flashcard?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _cards.removeWhere((c) => c.id == card.id));
      await _persist();
    }
  }

  void _startStudying() {
    if (_cards.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StudyScreen(cards: _cards)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Flashcards'),
        backgroundColor: Colors.transparent,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _cards.isEmpty
              ? const _EmptyState()
              : _buildCardList(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_cards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FloatingActionButton.extended(
                onPressed: _startStudying,
                icon: const Icon(Icons.school),
                label: const Text('Study'),
              ),
            ),
          FloatingActionButton(
            onPressed: _addCard,
            tooltip: 'Add flashcard',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildCardList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      itemCount: _cards.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final card = _cards[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              card.question,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                card.answer,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            onTap: () => _editCard(card),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent,
              onPressed: () => _deleteCard(card),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.style_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No flashcards yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first flashcard.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}