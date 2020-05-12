import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/selection.dart';
import 'package:mandrake/models/node.dart';

void main() {
  group('select', () {
    test('select a node', () {
      final selection = Selection();
      final node = Node('', Offset(0, 0));
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
      final node = Node('', Offset(0, 0));
      selection.select(node);
      expect(selection.selectedNode([node]), node);
      expect(selection.selectedNode([]), null);
    });
  });

  group('hover', () {
    test('hover a node', () {
      final selection = Selection();
      final node = Node('', Offset(0, 0));
      selection.hover(node);
      expect(selection.isNodeHovered(node), true);
    });

    test('hover null', () {
      final selection = Selection();
      final node = null;
      selection.select(node);
      expect(selection.isNodeHovered(node), false);
    });

    test('query hovered node providing node collection', () {
      final selection = Selection();
      final node = Node('', Offset(0, 0));
      selection.hover(node);
      expect(selection.hoveredNode([node]), node);
      expect(selection.hoveredNode([]), null);
    });
  });

  test('force invalidation when there is node selected', () {
    final selection = Selection();
    selection.select(Node());
    selection.addListener(() {
      expect(true, true);
    });
    selection.invalidate();
  });

  test('no force invalidation when there is no node selected', () {
    final selection = Selection();
    selection.addListener(() {
      expect(true, false);
    });
    selection.invalidate();
  });
}
