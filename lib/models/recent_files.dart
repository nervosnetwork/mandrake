import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

import '../io/foundation.dart';

/// TODO: convert web handle to string, or save that out of shared preferences.
class RecentFiles {
  static Future<UnmodifiableListView<FileHandle>> files() async {
    final storage = await _storage();
    return UnmodifiableListView(storage.map((e) => FileHandle(e)).toList());
  }

  static void push(FileHandle file) async {
    final current = await _storage();
    current.removeWhere((f) => f == file.handle);
    current.insert(0, file.handle as String);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, current);
  }

  static final String _storageKey = 'recent-files';

  static Future<List<String>> _storage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }
}
