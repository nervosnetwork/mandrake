import 'dart:ui' show Offset;
import 'dart:convert';

class OffsetJsonConverter {
  static Offset offsetFromJson(String json) {
    Map<String, dynamic> offset = jsonDecode(json);
    return Offset(offset['dx'] as double, offset['dy'] as double);
  }

  static String offsetToJson(Offset offset) => '{"dx":${offset.dx}, "dy":${offset.dy}}';
}
