import '../../models/node.dart';
import 'node_view.dart';
import 'root_node_view.dart';

class ViewCreator {
  static NodeView create(Node node) {
    if (node is RootNode) {
      return RootNodeView();
    }

    return NodeView();
  }
}
