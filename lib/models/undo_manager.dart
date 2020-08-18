import 'package:undo/undo.dart';
import 'command.dart';

export 'command.dart';

class UndoManager extends ChangeStack {
  static final UndoManager _shared = UndoManager();

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

void addCommandToUndoList(Command command) => UndoManager._shared.add(command);
bool get canUndo => UndoManager._shared.canUndo;
bool get canRedo => UndoManager._shared.canRedo;
void undo() => UndoManager._shared.undo();
void redo() => UndoManager._shared.redo();
