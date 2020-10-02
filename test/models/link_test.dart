import 'package:flutter_test/flutter_test.dart';
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
}
