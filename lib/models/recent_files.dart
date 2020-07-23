import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

class RecentFiles {
  static Future<UnmodifiableListView<String>> files() async {
    final storage = await _storage();
    return UnmodifiableListView(storage);
  }

  static void push(String file) async {
    final current = await _storage();
    current.removeWhere((f) => f == file);
    current.insert(0, file);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, current);
  }

  static final String _storageKey = 'recent-files';

  static Future<List<String>> _storage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }
}
