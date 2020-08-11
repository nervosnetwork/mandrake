import 'dart:ui' show Path, Offset;

class EdgePath {
  EdgePath(this.start, this.end);

  final Offset start;
  final Offset end;

  double get _controlOffset {
    final distance = (end - start).distance;
    return distance * 0.25;
  }

  Path get edgePath {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.cubicTo(
      start.dx + _controlOffset, // (end.dx > start.dx ? offset : -offset),
      start.dy, // + (end.dy > start.dy ? offset : -offset),
      end.dx - _controlOffset, //(end.dx > start.dx ? offset : -offset),
      end.dy, // - (end.dy > start.dy ? offset : -offset),
      end.dx,
      end.dy,
    );

    return path;
  }

  Path get arrowPath {
    final path = Path();
    path
      ..moveTo(end.dx, end.dy)
      ..relativeLineTo(-3, -2)
      ..relativeLineTo(0, 4)
      ..relativeLineTo(3, -2);
    return path;
  }
}
