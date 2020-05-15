import 'dart:ui' show PointMode;
import 'package:flutter/material.dart';

class CanvasLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      child: CustomPaint(
        painter: _CanvasGridPainter(Theme.of(context).textTheme.caption.color),
        child: Container(),
      ),
    );
  }
}

class _CanvasGridPainter extends CustomPainter {
  _CanvasGridPainter(this.gridColor);
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = gridColor;

    /* /// Grid mode
    for (var i = 20; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (var i = 20; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }*/
    /// Points mode
    final points = <Offset>[];
    for (var i = 20; i < size.width; i += 20) {
      for (var j = 20; j < size.height; j += 20) {
        points.add(Offset(i.toDouble(), j.toDouble()));
      }
    }

    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(_CanvasGridPainter oldPainter) => false;
}
