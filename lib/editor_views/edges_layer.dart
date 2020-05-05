import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/document.dart';
import '../models/node.dart';

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
      final path = Path();
      final start = nodes[i].position + Offset(120, 15);
      final end = nodes[i + 1].position + Offset(0, 15);
      final distance = (end - start).distance;
      final offset = distance * 0.25;

      path.moveTo(start.dx, start.dy);
      path.cubicTo(
        start.dx + offset, // (end.dx > start.dx ? offset : -offset),
        start.dy, // + (end.dy > start.dy ? offset : -offset),
        end.dx - offset, //(end.dx > start.dx ? offset : -offset),
        end.dy, // - (end.dy > start.dy ? offset : -offset),
        end.dx,
        end.dy,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_EdgesPainter oldPainter) => false;
}
