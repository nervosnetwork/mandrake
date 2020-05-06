import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document.dart';
import 'models/selection.dart';
import 'models/editor_state.dart';

import 'object_panel.dart';
import 'toolbar.dart';
import 'editor_views/canvas_layer.dart';
import 'editor_views/edges_layer.dart';
import 'editor_views/graphs_layer.dart';
import 'editor_views/drag_target_layer.dart';

class Editor extends StatelessWidget {
  final double _toolbarHeight = 40;
  final double _objectPanelWidth = 240;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Document>(create: (_) => Document()),
        ChangeNotifierProvider<Selection>(create: (_) => Selection()),
        ChangeNotifierProvider<EditorState>(create: (_) => EditorState()),
      ],
      child: LayoutBuilder(builder: (buildContext, constraints) {
        return Stack(
          children: [
            Positioned(
              top: _toolbarHeight,
              left: _objectPanelWidth,
              right: 0,
              bottom: 0,
              child: DesignEditor(),
            ),
            Positioned(
              top: _toolbarHeight,
              left: 0,
              right: constraints.maxWidth - _objectPanelWidth,
              bottom: 0,
              child: ObjectPanel(),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _toolbarHeight,
              child: Toolbar(),
            ),
          ],
        );
      }),
    );
  }
}

/// Graph design core editor.
class DesignEditor extends StatelessWidget {
  final double _canvasMargin = 20;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey[400],
        ),
        Positioned(
          left: _canvasMargin,
          top: _canvasMargin,
          right: _canvasMargin,
          bottom: _canvasMargin,
          child: Consumer<EditorState>(
            builder: (context, editorState, child) {
              return Transform(
                transform: Matrix4.translationValues(
                  editorState.canvasOffset.dx,
                  editorState.canvasOffset.dy,
                  0,
                )..scale(editorState.zoomScale, editorState.zoomScale, 1),
                child: Stack(
                  children: [
                    CanvasLayer(),
                    EdgesLayer(),
                    GraphsLayer(),
                    DragTargetLayer(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
