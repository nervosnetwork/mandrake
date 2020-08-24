@JS()
library testjs;

import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:html';

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
  if (handle.legacyWebFile) {
    final encoded = base64Encode(content);
    AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,$encoded')
      ..setAttribute('download', handle.name)
      ..click();
    return null;
  } else {
    final bytes = ByteData.view((content as Uint8List).buffer);
    return promiseToFuture(
      saveBinary(
        handle.handle,
        Blob(
          [bytes],
          'application/x-binary',
          'native',
        ),
      ),
    );
  }
}

/// Write file as string
Future<void> writeFileAsString(FileHandle handle, String content) {
  if (handle.legacyWebFile) {
    final encoded = base64Encode(utf8.encode(content));
    AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,$encoded')
      ..setAttribute('download', handle.name)
      ..click();
    return null;
  } else {
    return promiseToFuture(saveString(handle.handle, content));
  }
}

/// Read file as string
Future<String> readFileAsString(FileHandle handle) {
  if (isFileSystemAvailable()) {
    return promiseToFuture(readString(handle.handle));
  } else {
    final completer = Completer<String>();

    InputElement uploadInput = FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.accept = '.json';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = FileReader();

      reader.onLoadEnd.listen((e) {
        final result = reader.result;
        completer.complete(utf8.decode(result));
      });

      reader.onError.listen((fileEvent) {
        completer.completeError('Read file error');
      });

      reader.readAsArrayBuffer(file);
    });

    return completer.future;
  }
}

void writeStringToLocalStorage(String key, String content) async {
  window.localStorage[key] = content;
}

Future<String> readStringFromLocalStorage(String key) async {
  return window.localStorage[key];
}
