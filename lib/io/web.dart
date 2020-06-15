@JS()
library testjs;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'foundation.dart';

@JS()
class Promise<T> {
  external Promise(void Function(void Function(T result) resolve, Function reject) executor);
  external Promise then(void Function(T result) onFulfilled, [Function onRejected]);
}

@JS()
class FileSystemFileHandle {}

@JS()
class Blob {}

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

Future<FileHandle> openPanel({
  List<FileFilterGroup> allowedFileTypes,
}) async {
  final handle = await promiseToFuture(openFilePanel());
  if (handle == null) {
    return null;
  }
  return FileHandle(handle);
}

Future<FileHandle> savePanel({
  String suggestedFileName,
  List<FileFilterGroup> allowedFileTypes,
}) async {
  final handle = await promiseToFuture(saveFilePanel());
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
  return promiseToFuture(saveString(handle.handle, content));
}

/// Read file as string
Future<String> readFileAsString(FileHandle handle) {
  return promiseToFuture(readString(handle.handle));
}
