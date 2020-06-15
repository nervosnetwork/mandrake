@JS()
library testjs;

import 'package:js/js.dart';

import 'foundation.dart';

@JS()
class FileSystemFileHandle {}

@JS()
class Blob {}

@JS('window.openFilePanel')
external Future<FileSystemFileHandle> openFilePanel();

@JS('window.saveFilePanel')
external Future<FileSystemFileHandle> saveFilePanel();

@JS('window.readFileAsString')
external Future<String> readString(FileSystemFileHandle fileHandle);

@JS('window.saveFileAsString')
external Future<void> saveString(FileSystemFileHandle fileHandle, String contents);

@JS('window.saveFileAsBinary')
external Future<void> saveBinary(FileSystemFileHandle fileHandle, Blob contents);

Future<FileHandle> openPanel({
  List<FileFilterGroup> allowedFileTypes,
}) async {
  final handle = await openFilePanel();
  if (handle == null) {
    return null;
  }
  return FileHandle(handle);
}

Future<FileHandle> savePanel({
  String suggestedFileName,
  List<FileFilterGroup> allowedFileTypes,
}) async {
  final handle = await saveFilePanel();
  if (handle == null) {
    return null;
  }
  return FileHandle(handle);
}

/// Write file as bytes
Future<void> writeFile(FileHandle handle, List<int> content) {
  return Future.error('Web file save not implemented');
  // return await saveBinary(handle.handle as FileSystemFileHandle, content);
}

/// Write file as string
Future<void> writeFileAsString(FileHandle handle, String content) {
  return saveString(handle.handle, content);
}

/// Read file as string
Future<String> readFileAsString(FileHandle handle) {
  return readString(handle.handle as FileSystemFileHandle);
}
