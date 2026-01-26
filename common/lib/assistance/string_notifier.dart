import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberChoiceNotifier extends ChangeNotifier {
  static const _key = 'number_choice';

  String _value = 'mobile'; // ← デフォルト
  String get value => _value;

  NumberChoiceNotifier() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _value = prefs.getString(_key) ?? 'mobile'; // ← 無ければ1
    notifyListeners();
  }

  Future<void> set(String newValue) async {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newValue);
  }
}
