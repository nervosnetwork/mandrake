import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../io/foundation.dart';

class RecentFiles with ChangeNotifier {
  SharedPreferences _prefs;
  final List<FileHandle> _webStorage = [];

  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static final String _storageKey = 'recent-files';
  static final int _limit = 5;

  UnmodifiableListView<FileHandle> files() {
    List<FileHandle> handles;
    if (kIsWeb) {
      handles = _webStorage;
    } else {
      final storage = _desktopStorage();
      handles = storage.map((e) => FileHandle(e)).toList();
    }
    return UnmodifiableListView(handles);
  }

  void push(FileHandle file) async {
    if (kIsWeb) {
      _webStorage.removeWhere((f) => f == file.handle);
      _webStorage.insert(0, file.handle);
      if (_webStorage.length > _limit) {
        _webStorage.removeRange(_limit, _webStorage.length);
      }
    } else {
      final current = _desktopStorage();
      current.removeWhere((f) => f == file.handle);
      current.insert(0, file.handle as String);
      if (current.length > _limit) {
        current.removeRange(_limit, current.length);
      }
      await _prefs?.setStringList(_storageKey, current);
    }
  }

  List<String> _desktopStorage() {
    return _prefs?.getStringList(_storageKey) ?? [];
  }
}
