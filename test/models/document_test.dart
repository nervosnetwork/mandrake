import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/document.dart';
import 'package:mandrake/models/node.dart';

void main() {
  test('adding node increases node count', () {
    final doc = Document();
    doc.addListener(() {
      expect(doc.nodes.length, 1);
    });
    doc.addNode(Node(Offset(100, 200)));
  });

  test("change a node's position", () {
    final doc = Document();
    final node = Node(Offset(100, 200));
    doc.addNode(node);
    doc.moveNodePosition(node, Offset(100, 0));
    expect(doc.nodes[0].position, Offset(200, 200));
  });
}
