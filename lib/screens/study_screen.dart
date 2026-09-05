import 'package:flutter/material.dart';

import '../models/flashcard.dart';

class StudyScreen extends StatefulWidget {
  final List<Flashcard> cards;

  const StudyScreen({super.key, required this.cards});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int _index = 0;
  bool _showAnswer = false;

  Flashcard get _current => widget.cards[_index];

  void _previous() {
    setState(() {
      _index = (_index - 1 + widget.cards.length) % widget.cards.length;
      _showAnswer = false;
    });
  }

  void _next() {
    setState(() {
      _index = (_index + 1) % widget.cards.length;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card ${_index + 1} of ${widget.cards.length}'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _CardFace(
                    key: ValueKey(_showAnswer),
                    title: _showAnswer ? 'Answer' : 'Question',
                    content: _showAnswer ? _current.answer : _current.question,
                    isAnswer: _showAnswer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () => setState(() => _showAnswer = true),
                icon: const Icon(Icons.visibility),
                label: Text(_showAnswer ? 'Answer shown' : 'Show Answer'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previous,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _next,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Next'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final String title;
  final String content;
  final bool isAnswer;

  const _CardFace({
    super.key,
    required this.title,
    required this.content,
    required this.isAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = isAnswer ? scheme.primary : Colors.white;
    final fgColor = isAnswer ? scheme.onPrimary : scheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fgColor.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: fgColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}