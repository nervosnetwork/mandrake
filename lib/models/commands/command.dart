import 'package:undo/undo.dart';

class Command<T> extends Change {
  Command(
    oldValue,
    Function() execute,
    Function(T oldValue) undo,
  ) : super(oldValue, execute, undo);
}
