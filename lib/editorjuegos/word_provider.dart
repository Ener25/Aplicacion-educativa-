import 'package:flutter/material.dart';

class WordProvider with ChangeNotifier {
  List<String> _words = ['SOL', 'LUNA', 'MAR', 'CIELO', 'NUBE'];

  List<String> get words => _words;

  void addWord(String word) {
    _words.add(word.toUpperCase());
    notifyListeners();
  }

  void removeWord(String word) {
    _words.remove(word.toUpperCase());
    notifyListeners();
  }
}
