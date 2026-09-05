import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/flashcard.dart';

class StorageService {
  static const String _key = 'flashcards';

  static Future<List<Flashcard>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => Flashcard.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> save(List<Flashcard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(cards.map((c) => c.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}