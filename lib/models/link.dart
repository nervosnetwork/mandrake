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
}
