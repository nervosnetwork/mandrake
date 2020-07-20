import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'editor_dimensions.dart';
import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';
import '../../models/editor_state.dart';
import '../../models/link.dart';
import '../../utils/edge_path.dart';

/// Draw edges (between parent and child nodes).
/// Currently connecting (by dragging connector point from one node to another)
/// is not handled by this layer.
class EdgesLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<Document, Selection, EditorState>(
        builder: (context, document, selection, editorState, child) {
      final links =
          _visibleLinks(EditorDimensions.visibleCanvasArea(context).size, editorState, document);
      return CustomPaint(
        painter: _EdgesPainter(
          links,
          selection.selectedNode(document.nodes),
          editorState.canvasOffset,
        ),
        child: Container(),
      );
    });
  }

  List<Link> _visibleLinks(Size contextSize, EditorState state, Document doc) {
    final visibleArea = Rect.fromLTWH(
      -state.canvasOffset.dx,
      -state.canvasOffset.dy,
      contextSize.width / state.zoomScale,
      contextSize.height / state.zoomScale,
    );
    return doc.links.where((link) {
      return _isInsideVisibleArea(visibleArea, link);
    }).toList();
  }

  bool _isInsideVisibleArea(Rect visibleArea, Link link) {
    bool inside(Offset pos) => visibleArea.contains(pos);

    return inside(link.parent.position) ||
        inside(link.parent.size.bottomRight(link.parent.position)) ||
        inside(link.child.position) ||
        inside(link.child.size.bottomRight(link.child.position));
  }
}

class _EdgesPainter extends CustomPainter {
  _EdgesPainter(this.links, this.selectedNode, this.offset);

  List<Link> links;
  Node selectedNode;
  Offset offset;

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw a test edge between every two nodes.
    for (final link in links) {
      if (link.child == selectedNode) {
        paint.color = Colors.red[400];
      } else {
        paint.color = Colors.green;
      }

      final start = link.parent.childConnectorPosition(link.child) + offset;
      final end = link.child.position + Offset(0, 15) + offset;
      final edge = EdgePath(start, end);
      canvas.drawPath(edge.edgePath, paint);
      canvas.drawPath(edge.arrowPath, paint);
    }
  }

  @override
  bool shouldRepaint(_EdgesPainter oldPainter) => false;
}
