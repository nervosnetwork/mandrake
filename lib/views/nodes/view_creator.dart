import '../../models/node.dart';
import '../../models/selection.dart';
import 'node_view.dart';
import 'root_node_view.dart';

class ViewCreator {
  // TODO: remove selection; pass down with provider
  static NodeView create(Node node, Selection selection) {
    if (node is RootNode) {
      return RootNodeView(selection);
    }

    return NodeView(selection);
  }
}
