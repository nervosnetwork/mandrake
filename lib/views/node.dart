import '../models/node.dart';
import 'nodes/node_view.dart';
import 'nodes/ast_node_view.dart';
import 'nodes/primitive_node_view.dart';
import 'nodes/root_node_view.dart';

class ViewCreator {
  static NodeView create(Node node) {
    if (node is RootNode) {
      return RootNodeView();
    }

    if (node is PrimitiveNode) {
      return PrimitiveNodeView();
    }

    if (node is AstNode) {
      return AstNodeView();
    }

    return NodeView();
  }
}
