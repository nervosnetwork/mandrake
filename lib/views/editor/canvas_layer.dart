import 'dart:ui' show PointMode;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/editor_state.dart';

class CanvasLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gridColor = Theme.of(context).textTheme.caption.color;
    final editorState = Provider.of<EditorState>(context);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      child: CustomPaint(
        painter: _CanvasGridPainter(gridColor, editorState.canvasOffset),
        child: Container(),
      ),
    );
  }
}

class _CanvasGridPainter extends CustomPainter {
  _CanvasGridPainter(this._gridColor, this._canvasOffset);

  final Color _gridColor;
  final Offset _canvasOffset;
  final double _gridSize = 20;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = _gridColor;

    /* /// Grid mode
    for (var i = _gridSize; i < size.width; i += _gridSize) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (var i = _gridSize; i < size.height; i += _gridSize) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }*/
    /// Points mode

    final points = <Offset>[];
    var start = _canvasOffset % _gridSize;
    for (var i = start.dx; i < size.width; i += _gridSize) {
      for (var j = start.dy; j < size.height; j += _gridSize) {
        points.add(Offset(i.toDouble(), j.toDouble()));
      }
    }

    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(_CanvasGridPainter oldPainter) => false;
}
