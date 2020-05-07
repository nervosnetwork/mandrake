import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/node.dart';

void main() {
  test('equality', () {
    final one = Node();
    final two = Node();
    expect(one == one, true);
    expect(one == two, false);
    expect(one == null, false);
    // ignore: unrelated_type_equality_checks
    expect(one == 0, false);

    Node nullNode;
    expect(nullNode == null, true);
  });

  test('add child', () {
    final parent = Node();
    final child = Node();
    parent.addChild(child);
    expect(parent.children.contains(child), true);
    expect(parent.children.length, 1);

    parent.addChild(Node());
    expect(parent.children.length, 2);

    parent.addChild(child); // no re-entry
    expect(parent.children.length, 2);
  });

  group('get nodes', () {
    test('single node', () {
      final node = Node();
      expect(node.nodes, [node]);
    });

    test('tree', () {
      final parent = Node();
      final child1 = Node();
      parent.addChild(child1);
      final grandson = Node();
      child1.addChild(grandson);
      final child2 = Node();
      parent.addChild(child2);

      final nodes = parent.nodes;

      for (final node in [parent, child1, child2, grandson]) {
        expect(nodes, contains(node));
      }
    });
  });
}
