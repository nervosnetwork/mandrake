import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/editor_state.dart';

enum RulerDirection {
  horizontal,
  vertical,
}

Color _markerColor = Colors.grey[300];

/// Top left corner of rulers.
class RulerControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 1,
            color: _markerColor,
          ),
          bottom: BorderSide(
            width: 1,
            color: _markerColor,
          ),
        ),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class Ruler extends StatelessWidget {
  Ruler(this.direction);
  final RulerDirection direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: direction == RulerDirection.horizontal
          ? _drawHorizontal(context)
          : _drawVertical(context),
    );
  }

  Widget _drawHorizontal(BuildContext context) {
    final editorState = Provider.of<EditorState>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: _markerColor,
          ),
        ),
      ),
      child: CustomPaint(
        painter: _RulerPainter(
          direction,
          editorState.canvasOffset,
          editorState.zoomScale,
          Theme.of(context).textTheme.bodyText1.color,
        ),
        child: Container(),
      ),
    );
  }

  Widget _drawVertical(BuildContext context) {
    final editorState = Provider.of<EditorState>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 1,
            color: _markerColor,
          ),
        ),
      ),
      child: CustomPaint(
        painter: _RulerPainter(
          direction,
          editorState.canvasOffset,
          editorState.zoomScale,
          Theme.of(context).textTheme.bodyText1.color,
        ),
        child: Container(),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  _RulerPainter(this._direction, this._canvasOffset, this._scale, this._textColor);

  final RulerDirection _direction;
  final Offset _canvasOffset;
  final double _scale;
  final Color _textColor;
  double get _largeMarker {
    if (_scale < 0.6) {
      return 400.0;
    }
    if (_scale < 1.0) {
      return 200.0;
    }
    return 100.0;
  }

  double get _smallMarker {
    if (_scale <= 0.6) {
      return _largeMarker / 5;
    }
    return _largeMarker / 10;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _markerColor;

    final path = Path();
    final step = _smallMarker * _scale;
    if (_direction == RulerDirection.horizontal) {
      final start = _canvasOffset.dx % _smallMarker * _scale;
      for (var i = -2.0; i < size.width / step + 1; i++) {
        // Hackhack: the initial start iterator -2 is just to allow
        // the first label to have chance to draw. Same for the last
        // plus one offset. (example: top left large marker of the
        // horizontal rule.)
        final x = start + i * step;
        final position = (x / _scale - _canvasOffset.dx).round();
        final isLargeMarker = position % _largeMarker.toInt() == 0;
        final height = isLargeMarker ? size.height : size.height / 3;
        path.moveTo(x, size.height - height);
        path.lineTo(x, size.height);

        if (isLargeMarker) {
          final span = TextSpan(
            style: TextStyle(color: _textColor, fontSize: 10),
            text: '$position',
          );
          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(canvas, Offset(x + 4, 0));
        }
      }
    } else {
      final start = _canvasOffset.dy % _smallMarker * _scale;
      for (var i = 0.0; i < size.height / step + 1; i++) {
        final y = start + i * step;
        final position = (y / _scale - _canvasOffset.dy).round();
        final isLargeMarker = position % _largeMarker.toInt() == 0;
        final width = isLargeMarker ? size.width : size.width / 3;
        path.moveTo(size.width - width, y);
        path.lineTo(size.width, y);

        if (isLargeMarker) {
          final span = TextSpan(
            style: TextStyle(color: _textColor, fontSize: 10),
            text: '$position',
          );
          final textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          canvas.translate(0, y);
          canvas.rotate(-1.5708);
          textPainter.paint(canvas, Offset(4, 0));
          canvas.rotate(1.5708);
          canvas.translate(0, -y);
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_RulerPainter old) => false;
}
