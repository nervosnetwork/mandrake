class FileFilterGroup {
  const FileFilterGroup({this.label, this.extensions});

  final String label;
  final List<String> extensions;
}

class FileHandle {
  const FileHandle(this.handle, {this.name});

  /// For desktop, the handle will be the file path as string.
  /// For web, it will be a `FileSystemFileHandle`.
  final dynamic handle;
  final String name;

  bool get legacyWebFile => handle == null;
}
