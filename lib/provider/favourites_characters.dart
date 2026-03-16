import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/characters.dart';

class CharactersProvider extends ChangeNotifier {
  List<Personaje> _favourites = [];
  List<Personaje> get favourites => _favourites;

  CharactersProvider() {
    _loadFromDisk();
  }

  void toggleFavourite(Personaje personaje) {
    final isExist = _favourites.any((c) => c.id == personaje.id);
    if (isExist) {
      _favourites.removeWhere((c) => c.id == personaje.id);
    } else {
      _favourites.add(personaje);
    }
    _saveToDisk();
    notifyListeners();
  }

  void _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(_favourites.map((t) => t.toMap()).toList());
    await prefs.setString('my_favourites', data);
  }

  void _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('my_favourites');
    if (data != null) {
      final List decoded = json.decode(data);
      _favourites = decoded.map((m) => Personaje.fromMap(m)).toList();
      notifyListeners();
    }
  }
}
