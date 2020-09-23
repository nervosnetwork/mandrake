import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'editor_dimensions.dart';
import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/editor_state.dart';
import '../../models/node.dart';

import '../node.dart';

class NodesLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<Document, Selection, EditorState>(
      builder: (context, document, selection, editorState, child) {
        final contextSize = EditorDimensions.visibleCanvasArea(context).size;
        final visibleArea = Rect.fromLTWH(
          -editorState.canvasOffset.dx,
          -editorState.canvasOffset.dy,
          contextSize.width / editorState.zoomScale,
          contextSize.height / editorState.zoomScale,
        );
        final nodes = _visibleNodes(visibleArea, document);

        return Stack(
          clipBehavior: Clip.none,
          children: nodes.map((node) {
            return ChangeNotifierProvider<Node>.value(
              value: node,
              child: ViewCreator.create(node),
            );
          }).toList(),
        );
      },
    );
  }

  List<Node> _visibleNodes(Rect visibleArea, Document doc) {
    return doc.nodes.where((node) {
      return visibleArea.contains(node.position) ||
          visibleArea.contains(node.size.bottomRight(node.position));
    }).toList();
  }
}
