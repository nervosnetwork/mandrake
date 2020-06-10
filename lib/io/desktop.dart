import 'dart:io';

/// Write file as bytes
Future<File> writeFile(String path, List<int> content) {
  final file = File(path);
  return file.writeAsBytes(content);
}

/// Write file as string
Future<File> writeFileAsString(String path, String content) {
  final file = File(path);
  return file.writeAsString(content);
}

/// Read file as string
Future<String> readFileAsString(String path) {
  try {
    final file = File(path);
    return file.readAsString();
  } catch (e) {
    return null;
  }
}
