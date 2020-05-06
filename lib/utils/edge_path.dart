import 'dart:ui' show Path, Offset;

class EdgePath {
  final Offset start;
  final Offset end;

  EdgePath(this.start, this.end);

  Path get path {
    final distance = (end - start).distance;
    final offset = distance * 0.25;

    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.cubicTo(
      start.dx + offset, // (end.dx > start.dx ? offset : -offset),
      start.dy, // + (end.dy > start.dy ? offset : -offset),
      end.dx - offset, //(end.dx > start.dx ? offset : -offset),
      end.dy, // - (end.dy > start.dy ? offset : -offset),
      end.dx,
      end.dy,
    );

    return path;
  }
}
