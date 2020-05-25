import 'dart:ui' show Offset;

import '../../protos/ast.pb.dart' show Value_Type;
import 'ast_node.dart';

class LeafNode extends AstNode {
  LeafNode({
    Value_Type valueType,
    Offset position,
  }) : super(
          valueType: valueType,
          position: position,
        );
}
