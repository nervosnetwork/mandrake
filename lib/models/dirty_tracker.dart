class DirtyTracker {
  bool _dirty = false;

  bool get dirty => _dirty;
  void markDirty() => _dirty = true;
  void markClean() => _dirty = false;
}
