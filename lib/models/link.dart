import 'package:meta/meta.dart';
import 'node.dart';

/// Connection between two nodes: one parent and one child.
class Link {
  final Node parent;
  final Node child;

  Link({@required this.parent, @required this.child}): assert(parent != null && child != null);

  @override
  int get hashCode => parent.hashCode + child.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final Link typed = other;
    return parent == typed.parent && child == typed.child;
  }

  static List<Link> linksOf(Node node) {
    final links = node.children.map((e) => Link(parent: node, child: e)).toList();
    final childLinks = node.children
        .map((child) => linksOf(child))
        .fold(<Link>[], (previousValue, element) => previousValue + element);
    return links + childLinks;
  }
}
