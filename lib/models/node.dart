import 'dart:ui' show Offset;
import '../models/node.dart';

export 'nodes/node_base.dart';
export 'nodes/root_node.dart';

class NodeMeta {
  String type = 'todo';
}

class NodeCreator {
  static Node create(NodeMeta meta, Offset pos) {
    return Node('New Node', pos);
  }
}
