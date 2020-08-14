import 'dart:io';
import 'package:file_chooser/file_chooser.dart';

import 'foundation.dart';

bool isFileSystemAvailable() => true;

Future<FileHandle> openPanel({
  List<FileFilterGroup> allowedFileTypes,
}) async {
  final result = await showOpenPanel(
    allowedFileTypes: _convertFileTypes(allowedFileTypes),
    allowsMultipleSelection: false,
    canSelectDirectories: false,
  );
  if (result.canceled) {
    return null;
  } else {
    return FileHandle(result.paths.first, name: result.paths.first);
  }
}

Future<FileHandle> savePanel({
  String suggestedFileName,
  List<FileFilterGroup> allowedFileTypes,
}) async {
  final result = await showSavePanel(
    suggestedFileName: suggestedFileName,
    allowedFileTypes: _convertFileTypes(allowedFileTypes),
  );
  if (result.canceled) {
    return null;
  } else {
    return FileHandle(result.paths.first, name: result.paths.first);
  }
}

List<FileTypeFilterGroup> _convertFileTypes(List<FileFilterGroup> types) {
  if (types == null) {
    return null;
  }
  return types
      .map((t) => FileTypeFilterGroup(fileExtensions: t.extensions, label: t.label))
      .toList();
}

/// Write file as bytes
Future<File> writeFile(FileHandle handle, List<int> content) {
  final file = File(handle.handle);
  return file.writeAsBytes(content);
}

/// Write file as string
Future<File> writeFileAsString(FileHandle handle, String content) {
  final file = File(handle.handle);
  return file.writeAsString(content);
}

/// Read file as string
Future<String> readFileAsString(FileHandle handle) {
  try {
    final file = File(handle.handle);
    return file.readAsString();
  } catch (e) {
    return null;
  }
}

void writeStringToLocalStorage(String key, String content) => throw UnimplementedError();
String readStringFromLocalStorage(String key) => throw UnimplementedError();
