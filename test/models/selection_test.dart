import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/selection.dart';
import 'package:mandrake/models/node.dart';

void main() {
  group('select', () {
    test('select a node', () {
      final selection = Selection();
      final node = Node();
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
      final node = Node();
      selection.select(node);
      expect(selection.selectedNode([node]), node);
      expect(selection.selectedNode([]), null);
    });
  });

  group('hover', () {
    test('hover a node', () {
      final selection = Selection();
      final node = Node();
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
      final node = Node();
      selection.hover(node);
      expect(selection.hoveredNode([node]), node);
      expect(selection.hoveredNode([]), null);
    });
  });
}
