import 'package:undo/undo.dart';
export 'package:undo/undo.dart' show Change;

class UndoManager extends ChangeStack {
  static final UndoManager shared = UndoManager();
}
