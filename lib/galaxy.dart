import 'dart:math';
import 'package:flutter/material.dart';

class GalaxyView extends StatefulWidget {
  @override
  _GalaxyState createState() => _GalaxyState();
}

class _GalaxyState extends State<GalaxyView> {
  List<_Body> bodies = [];
  final canvasSize = Size(4096, 2160);
  Offset offset = Offset.zero;

  _createBodies() {
    setState(() {
      bodies.clear();

      for (var i = 0; i < 1000; i++) {
        bodies.add(
          _Body(
            Random().nextDouble() * 30,
            Offset(
              Random().nextDouble() * canvasSize.width,
              Random().nextDouble() * canvasSize.height,
            ),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    _createBodies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          color: Colors.black54,
        ),
        Listener(
          child: CustomPaint(
            size: size,
            painter: _BodyPainter(bodies, canvasSize, offset),
          ),
          onPointerMove: onPointerMove,
          onPointerUp: onPointerUp,
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: FlatButton(
            color: Colors.white,
            onPressed: _createBodies,
            child: Text(
              'Let there be stars',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onPointerMove(PointerMoveEvent event) {
    setState(() {
      offset += event.delta;
    });
  }

  void onPointerUp(PointerUpEvent event) {
  }
}

class _Body {
  double radius;
  Offset center;
  Color color;

  static const List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.white,
    Colors.pink,
    Colors.cyan,
    Colors.grey,
  ];

  _Body(this.radius, this.center)
      : color = _colors[Random().nextInt(_colors.length)];
}

class _BodyPainter extends CustomPainter {
  final List<_Body> bodies;
  final Size canvasSize;
  final Offset offset;

  _BodyPainter(this.bodies, this.canvasSize, [this.offset = Offset.zero]);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1;

    paint.color = Colors.blue[300];
    canvas.drawRect(Rect.fromPoints(offset, canvasSize.bottomRight(offset)), paint);
    paint.color = Colors.yellow;
    canvas.drawLine(
        offset, offset + Offset(canvasSize.width, canvasSize.height), paint);
    canvas.drawLine(
        offset + Offset(canvasSize.width, 0), offset + Offset(0, canvasSize.height), paint);

    for (var body in bodies) {
      paint.color = body.color;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(offset + body.center, body.radius, paint);
      paint.color = Colors.white;
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(offset + body.center, body.radius, paint);

      TextSpan span = TextSpan(
        text: '(${body.center.dx.toInt()}, ${body.center.dy.toInt()})',
        style: TextStyle(
          color: Colors.black,
          fontSize: 9,
        ),
      );
      TextPainter textPainter = TextPainter(text: span, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, offset + body.center);
    }
  }

  @override
  bool shouldRepaint(_BodyPainter oldDelegate) {
    return bodies != oldDelegate.bodies
      || canvasSize != oldDelegate.canvasSize
      || offset != oldDelegate.offset;
  }
}
