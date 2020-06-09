import 'dart:io';

Future<void> writeFile(String path, List<int> content) {
  final file = File(path);
  return file.writeAsBytes(content);
}
