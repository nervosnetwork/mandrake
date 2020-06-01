import 'package:flutter/material.dart';

class EditorDimensions {
  static const double toolbarHeight = 40;
  static const double objectLibraryPanelWidth = 180;
  static const double propertyInspectorPanelWidth = 280;
  static const double canvasMargin = 20;

  static Rect visibleCanvasArea(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Rect.fromLTWH(
      objectLibraryPanelWidth,
      toolbarHeight,
      size.width - objectLibraryPanelWidth - propertyInspectorPanelWidth,
      size.height - toolbarHeight,
    );
  }
}
