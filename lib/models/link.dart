import 'package:meta/meta.dart';
import 'node.dart';

/// Connection between two nodes: one parent and one child.
class Link {
  Link({@required this.parent, @required this.child}) : assert(parent != null && child != null);

  final Node parent;
  final Node child;

  @override
  bool operator ==(dynamic other) {
    return other is Link && parent == other.parent && child == other.child;
  }

  @override
  int get hashCode => parent.hashCode + child.hashCode;

  static List<Link> linksOf(Node node) {
    final links = node.children.map((e) => Link(parent: node, child: e)).toList();
    if (node.name == 'args' && node.children.length == 3) {
      final i = 1;
    }
    final childLinks = node.children
        .map((child) => linksOf(child))
        .fold(<Link>[], (previousValue, element) => previousValue + element);
    return links + childLinks;
  }
}
