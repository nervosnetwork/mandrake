import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/document.dart';
import '../models/link.dart';
import '../utils/edge_path.dart';

/// Draw edges (between parent and child nodes).
/// Currently connecting (by dragging connector point from one node to another)
/// is not handled by this layer.
class EdgesLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Document>(builder: (context, document, child) {
      return CustomPaint(
        painter: _EdgesPainter(document.links),
        child: Container(),
      );
    });
  }
}

class _EdgesPainter extends CustomPainter {
  List<Link> links;
  _EdgesPainter(this.links);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = Colors.green;

    // Draw a test edge between every two nodes.
    for (final link in links) {
      final start = link.parent.connectorPosition(link.child);
      final end = link.child.position + Offset(0, 15);
      final path = EdgePath(start, end).path;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_EdgesPainter oldPainter) => false;
}
