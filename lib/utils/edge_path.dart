import 'dart:ui' show Path, Offset;

class EdgePath extends Path {
  final Offset start;
  final Offset end;

  EdgePath(this.start, this.end) {
    final distance = (end - start).distance;
    final offset = distance * 0.25;

    moveTo(start.dx, start.dy);
    cubicTo(
      start.dx + offset, // (end.dx > start.dx ? offset : -offset),
      start.dy, // + (end.dy > start.dy ? offset : -offset),
      end.dx - offset, //(end.dx > start.dx ? offset : -offset),
      end.dy, // - (end.dy > start.dy ? offset : -offset),
      end.dx,
      end.dy,
    );
  }
}
