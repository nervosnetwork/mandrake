import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/document.dart';
import '../models/node.dart';
import '../utils/edge_path.dart';

/// Draw edges (between parent and child nodes).
/// Currently connecting (by dragging connector point from one node to another)
/// is not handled by this layer.
class EdgesLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Document>(builder: (context, document, child) {
      return CustomPaint(
        painter: _EdgesPainter(document.nodes),
        child: Container(),
      );
    });
  }
}

class _EdgesPainter extends CustomPainter {
  List<Node> nodes;
  _EdgesPainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = Colors.green;

    // Draw a test edge between every two nodes.
    for (var i = 0; i < nodes.length - 1; i++) {
      final start = nodes[i].position + Offset(120, 15);
      final end = nodes[i + 1].position + Offset(0, 15);
      final path = EdgePath(start, end);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_EdgesPainter oldPainter) => false;
}
