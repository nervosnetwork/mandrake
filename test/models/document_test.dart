import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/document.dart';
import 'package:mandrake/models/node.dart';

void main() {
  test('a document contains a root node by default', () {
    final doc = Document();
    expect(doc.nodes[0], isA<RootNode>());
  });

  test('adding node increases node count', () {
    final doc = Document();
    final count = doc.nodes.length;
    doc.addListener(() {
      expect(doc.nodes.length, count + 1);
    });
    doc.addNode(Node(position: Offset(100, 200)));
  });

  test("change a node's position", () {
    final doc = Document();
    final node = Node(position: Offset(100, 200));
    doc.addNode(node);
    doc.moveNodePosition(node, Offset(100, 0));
    expect(node.position, Offset(200, 200));
  });

  group('connect (links)', () {
    test('cannot add a node to multiple parents', () {
      final doc = Document();
      final node1 = Node(), node2 = Node(), node3 = Node();
      doc.addNode(node1);
      doc.addNode(node2, parent: node1);
      doc.addNode(node3);
      expect(doc.canConnect(parent: node1, child: node3), true);
      expect(doc.canConnect(parent: node3, child: node1), true);
      expect(doc.canConnect(parent: node3, child: node2), false);
    });

    test('cannot add null node', () {
      final doc = Document();
      final node1 = Node();
      doc.addNode(node1);
      expect(doc.canConnect(parent: null, child: null), false);
      expect(doc.canConnect(parent: node1, child: null), false);
      expect(doc.canConnect(parent: null, child: node1), false);
    });

    test('cannot add self', () {
      final doc = Document();
      final node1 = Node();
      doc.addNode(node1);
      expect(doc.canConnect(parent: node1, child: node1), false);
    });

    test('cannot add to descendants to form loop', () {
      final doc = Document();
      final node1 = Node(), node2 = Node(), node3 = Node();
      doc.addNode(node1);
      doc.addNode(node2, parent: node1);
      doc.addNode(node3);
      doc.connectNode(parent: node2, child: node3);
      expect(doc.canConnect(parent: node2, child: node1), false);
      expect(doc.canConnect(parent: node3, child: node1), false);
    });

    test('cannot add root node to other node as child', () {
      final doc = Document();
      final root = RootNode(), normal = Node();
      expect(doc.canConnect(parent: normal, child: root), false);
    });

    test('a node should be a top level node before it can be connected', () {
      final doc = Document();
      final node1 = Node(), node2 = Node();
      doc.addNode(node1);
      expect(() {
        doc.connectNode(parent: node1, child: node2);
      }, throwsA(isA<AssertionError>()));
    });

    test('a node should be in the doc before it can be connected', () {
      final doc = Document();
      final node1 = Node(), node2 = Node();
      doc.addNode(node2);
      expect(() {
        doc.connectNode(parent: node1, child: node2);
      }, throwsA(isA<AssertionError>()));
    });
  });

  group('disconnect (links)', () {
    test('a node becomes top level node after it is disconnected from parent', () {
      final doc = Document();
      final node1 = Node(), node2 = Node(), node3 = Node();
      doc.addNode(node1);
      doc.addNode(node2);
      doc.addNode(node3);
      doc.connectNode(parent: node1, child: node3);
      expect(doc.canConnect(parent: node2, child: node3), false);
      doc.disconnectNode(parent: node1, childId: node3.id);
      expect(doc.canConnect(parent: node2, child: node3), true);
      expect(node1.children.contains(node3), false);
      expect(node2.children.contains(node3), false);
    });

    test('disconnect from parent', () {
      final doc = Document();
      final node1 = Node(), node2 = Node();
      doc.addNode(node1);
      doc.addNode(node2);
      doc.connectNode(parent: node1, child: node2);
      expect(node1.children.contains(node2), true);
      doc.disconnectNodeFromParent(node2);
      expect(doc.canConnect(parent: node1, child: node2), true);
      expect(node1.children.contains(node2), false);
      //todo
    });

    test('disconnect all children', () {
      final doc = Document();
      final node1 = Node(), node2 = Node(), node3 = Node();
      doc.addNode(node1);
      doc.addNode(node2);
      doc.addNode(node3);
      doc.connectNode(parent: node1, child: node2);
      doc.connectNode(parent: node1, child: node3);
      doc.disconnectAllChildren(node1);
      expect(doc.canConnect(parent: node1, child: node2), true);
      expect(doc.canConnect(parent: node1, child: node3), true);
    });
  });

  test('delete node', () {
    final doc = Document();
    final node1 = Node(), node2 = Node(), node3 = Node();
    doc.addNode(node1);
    doc.addNode(node2);
    doc.addNode(node3);
    doc.connectNode(parent: node1, child: node2);
    doc.connectNode(parent: node2, child: node3);
    doc.deleteNode(node2);
    expect(doc.canConnect(parent: node1, child: node3), true);
    expect(doc.nodes.contains(node1), true);
    expect(doc.nodes.contains(node3), true);
    expect(doc.nodes.contains(node2), false);
  });

  test('delete node and descendants', () {
    final doc = Document();
    final node1 = Node(), node2 = Node(), node3 = Node(), node4 = Node();
    doc.addNode(node1);
    doc.addNode(node2);
    doc.addNode(node3);
    doc.addNode(node4);
    doc.connectNode(parent: node1, child: node2);
    doc.connectNode(parent: node2, child: node3);
    doc.connectNode(parent: node3, child: node4);
    doc.deleteNodeAndDescendants(node2);
    expect(doc.nodes.contains(node1), true);
    expect(doc.nodes.contains(node2), false);
    expect(doc.nodes.contains(node3), false);
    expect(doc.nodes.contains(node4), false);
  });

  test('parent of', () {
    final doc = Document();
    final node1 = Node(), node2 = Node();
    doc.addNode(node1);
    doc.addNode(node2);
    doc.connectNode(parent: node1, child: node2);
    expect(doc.parentOf(node2), node1);
  });
}
