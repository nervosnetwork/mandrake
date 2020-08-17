import 'package:undo/undo.dart';
export 'package:undo/undo.dart' show Change;

class UndoManager extends ChangeStack {
  static final UndoManager shared = UndoManager();

  UndoManager() : super() {
    /// The `undo` library we use assumes that there should be at least one history item
    /// to enable undo. Add one dummy change to satisfy that.
    /// https://github.com/rodydavis/undo/blob/master/lib/src/undo_stack.dart#L16-L17
    add(Change(
      0,
      () {},
      (_) {},
    ));
  }
}
