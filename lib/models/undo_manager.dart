import 'package:undo/undo.dart';

import 'command.dart';

class UndoManager {
  final ChangeStack _stack = ChangeStack();
  static final UndoManager _shared = UndoManager();

  UndoManager() : super() {
    clear();
  }

  factory UndoManager.shared() => _shared;

  void clear() {
    _stack.clearHistory();

    /// The `undo` library we use assumes that there should be at least one history item
    /// to enable undo. Add one dummy change to satisfy that.
    /// https://github.com/rodydavis/undo/blob/master/lib/src/undo_stack.dart#L16-L17
    _stack.add(Change(
      0,
      () {},
      (_) {},
    ));
  }

  bool get canUndo => _stack.canUndo;
  bool get canRedo => _stack.canRedo;

  void add(Command change) {
    _stack.add(change);
    CommandState.shared().update();
  }

  void undo() {
    _stack.undo();
    CommandState.shared().update();
  }

  void redo() {
    _stack.redo();
    CommandState.shared().update();
  }
}

void runCommand(Command command) => UndoManager._shared.add(command);
void undo() => UndoManager._shared.undo();
void redo() => UndoManager._shared.redo();
