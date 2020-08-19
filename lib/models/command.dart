import 'package:flutter/material.dart' show Offset;
import 'package:undo/undo.dart';

import 'document.dart';
import 'selection.dart';
import 'node.dart';
import 'undo_manager.dart';

/// Encapsulate action/change that supports undo/redo
class Command<T> extends Change {
  Command(
    oldValue,
    Function() execute,
    Function(T oldValue) undo,
  ) : super(oldValue, execute, undo);

  /// Execute, adding to undo list
  void run() => addCommandToUndoList(this);

  factory Command.createNode(
    Document doc,
    Selection selection,
    NodeTemplate template,
    Offset pos,
  ) {
    Node node;
    return Command(
      selection.selectedNode(doc.nodes)?.id,
      () {
        node = NodeCreator.create(template, pos);
        if (!doc.nodes.contains((node))) {
          // NodeCreator is free to add the node to document if it wants to.
          doc.addNode(node);
        }
        selection.select(node);
      },
      (previousSelectedNodeId) {
        selection.select(doc.findNode(previousSelectedNodeId as String));
        doc.deleteNode(node);
      },
    );
  }

  factory Command.deleteNode(Document doc, Selection selection, Node node) {
    final parentSlotIds = {for (var n in doc.parentsOf(node)) n.id: n.slotIdForChild(node)};
    final childSlotIds = {for (var n in node.children) n.id: node.slotIdForChild(n)};

    return Command(
      [parentSlotIds, childSlotIds],
      () {
        doc.deleteNode(node);
        selection.select(null);
      },
      (slotIds) {
        doc.addNode(node);

        final parents = (slotIds as List<Map<String, String>>)[0];
        for (final parentId in parents.keys) {
          final parent = doc.findNode(parentId);
          doc.connectNode(parent: parent, child: node, slotId: parents[parentId]);
        }

        final children = (slotIds as List<Map<String, String>>)[1];
        for (final childId in children.keys) {
          final child = doc.findNode(childId);
          doc.connectNode(parent: node, child: child, slotId: children[childId]);
        }

        selection.select(node);
      },
    );
  }

  factory Command.deleteNodeAndDescendants(Document doc, Selection selection, Node node) {
    return Command(
      node,
      () {
        doc.deleteNodeAndDescendants(node);
        selection.select(null);
      },
      (node) {
        // TODO: undo delete and descendants
      },
    );
  }

  factory Command.renameNode(Node node, String name) {
    return Command(
      node.name,
      () {
        node.name = name;
      },
      (oldName) {
        node.name = oldName as String;
      },
    );
  }

  factory Command.updateProperty(PrefabNode node, String name, String value) {
    return Command(
      [name, node.getProperty(name) ?? ''],
      () {
        node.updateProperty(name, value);
      },
      (oldValue) {
        final nameAndValue = oldValue as List<String>;
        node.updateProperty(nameAndValue[0], nameAndValue[1]);
      },
    );
  }

  factory Command.updateValue(PrimitiveNode node, String value) {
    return Command(
      node.value,
      () {
        node.value = value;
      },
      (oldValue) {
        node.value = oldValue as String;
      },
    );
  }

  factory Command.updateValueType(AstNode node, ValueType valueType) {
    return Command(
      node.valueType,
      () {
        node.valueType = valueType;
      },
      (oldValue) {
        node.valueType = oldValue as ValueType;
      },
    );
  }

  factory Command.movePosition(Node node, Offset newPos, [Offset oldPos]) {
    return Command(
      oldPos ?? node.position,
      () {
        node.position = newPos;
      },
      (oldPosition) {
        node.position = oldPosition as Offset;
      },
    );
  }

  factory Command.connect(Document doc, Node parent, Node node, ChildSlot slot) {
    return Command(
      node,
      () {
        doc.connectNode(parent: parent, child: node, slotId: slot?.id);
      },
      (node) {
        doc.disconnectNodeFromParent(node as Node);
      },
    );
  }

  factory Command.disconnectParent(Document doc, Node node) {
    final parents = doc.parentsOf(node);
    final slotIds = {for (var parent in parents) parent.id: parent.slotIdForChild(node)};
    return Command(
      slotIds,
      () {
        doc.disconnectNodeFromParent(node);
      },
      (parents) {
        for (final parentId in (parents as Map<String, String>).keys) {
          final parent = doc.findNode(parentId);
          doc.connectNode(
            parent: parent,
            child: node,
            slotId: (parents as Map<String, String>)[parentId],
          );
        }
      },
    );
  }

  factory Command.disconnectChildren(Document doc, Node node) {
    final slotIds = {for (var n in node.children) n.id: node.slotIdForChild(n)};
    return Command(
      slotIds,
      () {
        doc.disconnectAllChildren(node);
      },
      (childIds) {
        for (final childId in (childIds as Map<String, String>).keys) {
          final child = doc.findNode(childId);
          doc.connectNode(
            parent: node,
            child: child,
            slotId: (childIds as Map<String, String>)[childId],
          );
        }
      },
    );
  }

  factory Command.renameSlot(Node node, ChildSlot slot, String name) {
    return Command(
      slot.name,
      () {
        node.renameSlot(slot.id, name);
      },
      (oldName) {
        node.renameSlot(slot.id, oldName as String);
      },
    );
  }

  factory Command.deleteSlot(Document doc, Node node, ChildSlot slot) {
    final slotName = slot.name;
    final childId = slot.childId;
    // TODO: root node streams/calls restore
    // TODO: slot original position restore (otherwise slot is always appended when undo)
    return Command(
      [slotName, childId],
      () {
        if (slot.childId != null) {
          doc.disconnectNode(parent: node, childId: slot.childId);
        }
        node.removeSlot(slot.id);
      },
      (slotNameAndChildId) {
        final slot = node.addSlot((slotNameAndChildId as List<String>)[0]);
        final childId = (slotNameAndChildId as List<String>)[1];
        if (childId != null) {
          final child = doc.findNode(childId);
          doc.connectNode(parent: node, child: child, slotId: slot.id);
        }
      },
    );
  }

  factory Command.flatten(Document doc, Selection selection, PrefabNode node) {
    List<AstNode> flattened;
    return Command(
      node,
      () {
        flattened = doc.flattenPrefabNode(node);
        selection.select(flattened.first);
      },
      (oldNode) {
        final node = oldNode as PrefabNode;
        selection.select(node);

        final firstFlattened = flattened.first;
        final parents = doc.parentsOf(firstFlattened);
        if (parents.isNotEmpty) {
          for (final parent in parents) {
            parent.replaceChild(firstFlattened.id, node);
          }
        } else {
          final index = doc.topLevelNodes.indexOf(firstFlattened);
          doc.topLevelNodes[index] = node;
        }

        for (final n in flattened) {
          doc.deleteNodeAndDescendants(n);
        }
      },
    );
  }

  factory Command.autoLayout(Document doc, AstNode node) {
    final positions = {for (var n in node.nodes) n.id: n.position};
    return Command(
      positions,
      () {
        node.autoLayout();
        doc.forceRedraw();
      },
      (oldPositions) {
        final positions = oldPositions as Map<String, Offset>;
        for (final n in node.nodes) {
          n.position = positions[n.id];
        }
        doc.forceRedraw();
      },
    );
  }
}
