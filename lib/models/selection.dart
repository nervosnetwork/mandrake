import 'node.dart';

class Selection {
  String _selectedNodeId;

  void select(Node node) => _selectedNodeId = node?.id;
  bool isNodeSelected(Node node) => _selectedNodeId == node.id;
  Node selectedNode(List<Node> nodes) {
    return nodes.firstWhere((node) => isNodeSelected(node), orElse: () => null);
  }
}
