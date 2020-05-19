import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document.dart';
import 'models/selection.dart';
import 'models/editor_state.dart';

import 'toolbar.dart';
import 'object_library.dart';
import 'property_inspector.dart';

import 'views/editor/editor_dimensions.dart';
import 'views/editor/canvas_layer.dart';
import 'views/editor/edges_layer.dart';
import 'views/editor/nodes_layer.dart';
import 'views/editor/pointer_layer.dart';

class Editor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Document>(create: (_) {
          final doc = Document();
          final initialCanvasSize = EditorDimensions.visibleCanvasArea(context).size -
              Offset(
                EditorDimensions.canvasMargin * 2,
                EditorDimensions.canvasMargin * 2,
              );
          doc.resizeCanvas(initialCanvasSize);
          return doc;
        }),
        ChangeNotifierProvider<Selection>(create: (_) => Selection()),
        ChangeNotifierProvider<EditorState>(create: (_) => EditorState()),
      ],
      child: Stack(
        children: [
          Positioned(
            top: EditorDimensions.toolbarHeight,
            left: EditorDimensions.objectLibraryPanelWidth,
            right: EditorDimensions.propertyInspectorPanelWidth,
            bottom: 0,
            child: DesignEditor(),
          ),
          Positioned(
            top: EditorDimensions.toolbarHeight,
            left: 0,
            bottom: 0,
            width: EditorDimensions.objectLibraryPanelWidth,
            child: ObjectLibrary(),
          ),
          Positioned(
            top: EditorDimensions.toolbarHeight,
            bottom: 0,
            right: 0,
            width: EditorDimensions.propertyInspectorPanelWidth,
            child: PropertyInspector(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: EditorDimensions.toolbarHeight,
            child: Toolbar(),
          ),
        ],
      ),
    );
  }
}

/// Graph design core editor.
class DesignEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);

    return Stack(
      children: [
        Container(
          color: Theme.of(context).dialogBackgroundColor,
        ),
        Positioned(
          left: EditorDimensions.canvasMargin,
          top: EditorDimensions.canvasMargin,
          width: document.canvasSize.width,
          height: document.canvasSize.height,
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
                    NodesLayer(),
                    PointerLayer(),
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
