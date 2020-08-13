@JS()
library testjs;

import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'dart:typed_data';
import 'dart:html' show Blob;

import 'foundation.dart';

@JS()
class Promise<T> {
  external Promise(void Function(void Function(T result) resolve, Function reject) executor);
  external Promise then(void Function(T result) onFulfilled, [Function onRejected]);
}

@JS()
class FileSystemFileHandle {}

@JS('window.isFileSystemAvailable')
external bool isFileSystemAvailable();

@JS('window.openFilePanel')
external Promise<FileSystemFileHandle> openFilePanel();

@JS('window.saveFilePanel')
external Promise<FileSystemFileHandle> saveFilePanel();

@JS('window.readFileAsString')
external Promise<String> readString(FileSystemFileHandle fileHandle);

@JS('window.saveFileAsString')
external Promise<void> saveString(FileSystemFileHandle fileHandle, String contents);

@JS('window.saveFileAsBinary')
external Promise<void> saveBinary(FileSystemFileHandle fileHandle, Blob contents);

@JS('window.getFileName')
external String getFileName(FileSystemFileHandle fileHandle);

Future<FileHandle> openPanel({
  List<FileFilterGroup> allowedFileTypes,
}) async {
  final handle = await promiseToFuture(openFilePanel());
  if (handle == null) {
    return null;
  }
  return FileHandle(handle, name: getFileName(handle));
}

Future<FileHandle> savePanel({
  String suggestedFileName,
  List<FileFilterGroup> allowedFileTypes,
}) async {
  final handle = await promiseToFuture(saveFilePanel());
  if (handle == null) {
    return null;
  }
  return FileHandle(handle, name: getFileName(handle));
}

/// Write file as bytes
Future<void> writeFile(FileHandle handle, List<int> content) {
  final bytes = ByteData.view((content as Uint8List).buffer);
  return promiseToFuture(
    saveBinary(handle.handle, Blob([bytes], 'application/x-binary', 'native')),
  );
}

/// Write file as string
Future<void> writeFileAsString(FileHandle handle, String content) {
  return promiseToFuture(saveString(handle.handle, content));
}

/// Read file as string
Future<String> readFileAsString(FileHandle handle) {
  return promiseToFuture(readString(handle.handle));
}
