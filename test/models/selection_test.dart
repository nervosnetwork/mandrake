import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/selection.dart';
import 'package:mandrake/models/document.dart';
import 'package:mandrake/models/node.dart';

void main() {
  group('select', () {
    test('select a node', () {
      final doc = Document(allNodes: {});
      final selection = Selection(doc);
      final node = Node();
      selection.select(node);
      expect(selection.isNodeSelected(node), true);
    });

    test('select null', () {
      final doc = Document(allNodes: {});
      final selection = Selection(doc);
      final node = null;
      selection.select(node);
      expect(selection.isNodeSelected(node), false);
    });

    test('query selected node providing node collection', () {
      final doc = Document(allNodes: {});
      final selection = Selection(doc);
      final node = Node();
      selection.select(node);
      expect(selection.selectedNode, null);
      doc.addNode(node);
      expect(selection.selectedNode, node);
    });
  });

  group('hover', () {
    test('hover a node', () {
      final doc = Document(allNodes: {});
      final selection = Selection(doc);
      final node = Node();
      selection.hover(node);
      expect(selection.isNodeHovered(node), true);
    });

    test('hover null', () {
      final doc = Document(allNodes: {});
      final selection = Selection(doc);
      final node = null;
      selection.select(node);
      expect(selection.isNodeHovered(node), false);
    });

    test('query hovered node providing node collection', () {
      final doc = Document(allNodes: {});
      final selection = Selection(doc);
      final node = Node();
      selection.hover(node);
      expect(selection.hoveredNode, null);
      doc.addNode(node);
      expect(selection.hoveredNode, node);
    });
  });
}
