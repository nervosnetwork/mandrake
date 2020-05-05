import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/selection.dart';
import 'package:mandrake/models/node.dart';

void main() {
  test('select a node', () {
    final selection = Selection();
    final node = Node(Offset(0, 0));
    selection.select(node);
    expect(selection.isNodeSelected(node), true);
  });

  test('select null', () {
    final selection = Selection();
    final node = null;
    selection.select(node);
    expect(selection.isNodeSelected(node), false);
  });

  test('query selected node providing node collection', () {
    final selection = Selection();
    final node = Node(Offset(0, 0));
    selection.select(node);
    expect(selection.selectedNode([node]), node);
    expect(selection.selectedNode([]), null);
  });
}
