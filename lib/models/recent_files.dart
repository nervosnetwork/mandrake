import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../io/foundation.dart';

/// TODO: convert web handle to string, or save that out of shared preferences.
class RecentFiles with ChangeNotifier {
  SharedPreferences _prefs;

  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static final String _storageKey = 'recent-files';

  UnmodifiableListView<FileHandle> files() {
    final storage = _storage();
    return UnmodifiableListView(storage.map((e) => FileHandle(e)).toList());
  }

  void push(FileHandle file) async {
    final current = _storage();
    current.removeWhere((f) => f == file.handle);
    current.insert(0, file.handle as String);
    await _prefs?.setStringList(_storageKey, current);
  }

  List<String> _storage() {
    return _prefs?.getStringList(_storageKey) ?? [];
  }
}
