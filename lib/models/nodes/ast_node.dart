import 'dart:ui' show Offset;

import '../../protos/ast.pb.dart' show Value_Type;
import 'node_base.dart';

class AstNode extends Node {
  AstNode({
    this.valueType,
    Offset position,
    minimumSlotCount = 1,
    maximumSlotCount = 1,
  }) : super(
          name: valueType.uiName,
          position: position,
          minimumSlotCount: minimumSlotCount,
          maximumSlotCount: maximumSlotCount,
        );

  final Value_Type valueType;
}

extension ValueTypeName on Value_Type {
  String get uiName {
    final separated = toString().split('_');
    return separated.map((w) {
      if (['JSON', 'DAO'].contains(w)) {
        return w;
      }
      return w[0] + w.substring(1).toLowerCase();
    }).join(' ');
  }
}
