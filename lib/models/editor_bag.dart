import 'package:flutter/material.dart';

// Hold global editor data, until we bring more complicated state lib.
class EditorBag {
  Offset lastDropOffset = Offset.zero; // Remove this when DragTaget includes offset.
}

final EditorBag editorBag = EditorBag();
