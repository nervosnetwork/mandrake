import 'web.dart' if (dart.library.io) 'desktop.dart';
import 'foundation.dart';
export 'foundation.dart';

Future<FileHandle> showOpenPanel({
  List<FileFilterGroup> allowedFileTypes,
}) {
  return openPanel(allowedFileTypes: allowedFileTypes);
}

Future<FileHandle> showSavePanel({
  String suggestedFileName,
  List<FileFilterGroup> allowedFileTypes,
}) {
  return savePanel(
    suggestedFileName: suggestedFileName,
    allowedFileTypes: allowedFileTypes,
  );
}
