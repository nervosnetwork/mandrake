import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/document.dart';
import 'package:mandrake/models/node.dart';
import 'package:mandrake/models/link.dart';

void main() {
  test('equality', () {
    final node1 = Node();
    final node2 = Node();
    final link = Link(parent: node1, child: node2);
    expect(link == link, true);
    expect(link == Link(parent: node1, child: node2), true);
    expect(link == Link(parent: node2, child: node1), false);
    expect(link == Link(parent: Node(), child: Node()), false);
    expect(link == null, false);
    // ignore: unrelated_type_equality_checks
    expect(link == Node(), false);

    Node nullNode;
    expect(nullNode == null, true);
  });

  test('constructor requies non-null nodes', () {
    expect(() {
      Link(parent: null, child: Node());
    }, throwsA(isA<AssertionError>()));
    expect(() {
      Link(parent: Node(), child: null);
    }, throwsA(isA<AssertionError>()));
    expect(() {
      Link(parent: null, child: null);
    }, throwsA(isA<AssertionError>()));
  });

  test("get a node's links recursively", () {
    final doc = Document(allNodes: {});
    final child1 = Node();
    doc.addNode(child1);
    final grandson1 = Node();
    final grandson2 = Node();
    child1..addChild(grandson1)..addChild(grandson2);
    final child2 = Node();
    doc.addNode(child2);
    final father = Node();
    doc.addNode(father);
    father..addChild(child1)..addChild(child2);

    final links = Link.linksOf(father);
    expect(links.length, 4);

    final expectedLinks = [
      Link(parent: father, child: child1),
      Link(parent: father, child: child2),
      Link(parent: child1, child: grandson1),
      Link(parent: child1, child: grandson2),
    ];
    for (final link in expectedLinks) {
      expect(links, contains(link));
    }
  });
}
