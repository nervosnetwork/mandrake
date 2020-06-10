import 'dart:ui' show Offset;

class OffsetJsonConverter {
  static Offset offsetFromJson(Map<String, dynamic> json) {
    return Offset(json['dx'] as double, json['dy'] as double);
  }

  static Map<String, dynamic> offsetToJson(Offset offset) => {
        'dx': offset.dx,
        'dy': offset.dy,
      };
}
