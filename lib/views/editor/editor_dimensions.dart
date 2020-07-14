import 'package:flutter/material.dart';

class EditorDimensions {
  static const double toolbarHeight = 40;
  static const double mainMenuWidth = 300;
  static const double rulerWidth = 20;
  static const double objectLibraryPanelWidth = 200;
  static const double propertyInspectorPanelWidth = 280;

  static Rect visibleCanvasArea(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Rect.fromLTWH(
      objectLibraryPanelWidth + rulerWidth,
      toolbarHeight + rulerWidth,
      size.width - objectLibraryPanelWidth - propertyInspectorPanelWidth - rulerWidth,
      size.height - toolbarHeight - rulerWidth,
    );
  }
}
