import 'package:undo/undo.dart';

class UndoManager extends ChangeStack {
  static final UndoManager shared = UndoManager();
}
