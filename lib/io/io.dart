import 'web.dart' if (dart.library.io) 'desktop.dart' as fs;

bool isFileSystemAvailable() => fs.isFileSystemAvailable();
