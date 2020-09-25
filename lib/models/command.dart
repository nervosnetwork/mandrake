import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Offset;
import 'package:undo/undo.dart';

import 'document.dart';
import 'selection.dart';
import 'node.dart';
import 'undo_manager.dart';

class CommandState with ChangeNotifier {
  static final CommandState _shared = CommandState._();

  CommandState._();

  factory CommandState.shared() => _shared;

  void update() => notifyListeners();
}

/// Encapsulate action/change that supports undo/redo
class Command<T> extends Change {
  Command(
    oldValue,
    Function() execute,
    Function(T oldValue) undo,
  ) : super(oldValue, execute, undo);

  /// Execute, adding to undo list
  void run() => runCommand(this);

  factory Command.createNode(
    Document doc,
    Selection selection,
    NodeTemplate template,
    Offset pos,
  ) {
    String nodeId;
    String serializedNode;
    return Command(
      selection.selectedNode(doc.nodes)?.id,
      () {
        Node node;
        if (serializedNode != null) {
          // Redo
          final json = jsonDecode(serializedNode);
          node = Node.fromJson(json);
        } else {
          node = NodeCreator.create(template, pos);
        }
        node.doc = doc;
        doc.addNode(node);
        selection.select(node);
        nodeId = node.id;
      },
      (previousSelectedNodeId) {
        selection.select(doc.findNode(previousSelectedNodeId as String));
        final node = doc.findNode(nodeId);
        serializedNode = jsonEncode(node);
        doc.deleteNode(node);
      },
    );
  }

  factory Command.deleteNode(Document doc, Selection selection, Node node) {
    final parentSlotIds = {for (var n in doc.parentsOf(node)) n.id: n.slotIdForChild(node)};
    final childSlotIds = {for (var n in node.children) n.id: node.slotIdForChild(n)};
    final serialized = jsonEncode(node);
    final nodeId = node.id;

    return Command(
      [parentSlotIds, childSlotIds],
      () {
        doc.deleteNode(doc.findNode(nodeId));
        selection.select(null);
      },
      (slotIds) {
        final node = Node.fromJson(jsonDecode(serialized));
        node.doc = doc;
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
    final parents = doc.parentsOf(node);
    final slotIds = {for (var parent in parents) parent.id: parent.slotIdForChild(node)};
    return Command(
      node.nodes.map((e) => jsonEncode(e)).toList(),
      () {
        doc.deleteNodeAndDescendants(node);
        selection.select(null);
      },
      (jsons) {
        final nodes = (jsons as List<String>).map(jsonDecode).map((json) => Node.fromJson(json));
        for (final node in nodes) {
          doc.addNode(node);
        }

        for (final parentId in slotIds.keys) {
          final parent = doc.findNode(parentId);
          doc.connectNode(
            parent: parent,
            child: node,
            slotId: slotIds[parentId],
          );
        }
        selection.select(node);
      },
    );
  }

  factory Command.renameNode(Document doc, Node node, String name) {
    final nodeId = node.id;
    return Command(
      node.name,
      () {
        doc.findNode(nodeId).name = name;
      },
      (oldName) {
        doc.findNode(nodeId).name = oldName as String;
      },
    );
  }

  factory Command.updateProperty(Document doc, PrefabNode node, String name, String value) {
    final nodeId = node.id;
    return Command(
      [name, node.getProperty(name) ?? ''],
      () {
        (doc.findNode(nodeId) as PrefabNode).updateProperty(name, value);
      },
      (oldValue) {
        final nameAndValue = oldValue as List<String>;
        (doc.findNode(nodeId) as PrefabNode).updateProperty(nameAndValue[0], nameAndValue[1]);
      },
    );
  }

  factory Command.updateValue(Document doc, PrimitiveNode node, String value) {
    final nodeId = node.id;
    return Command(
      node.value,
      () {
        (doc.findNode(nodeId) as PrimitiveNode).value = value;
      },
      (oldValue) {
        (doc.findNode(nodeId) as PrimitiveNode).value = oldValue as String;
      },
    );
  }

  factory Command.updateValueType(Document doc, AstNode node, ValueType valueType) {
    final nodeId = node.id;
    return Command(
      node.valueType,
      () {
        (doc.findNode(nodeId) as AstNode).valueType = valueType;
      },
      (oldValue) {
        (doc.findNode(nodeId) as AstNode).valueType = oldValue as ValueType;
      },
    );
  }

  factory Command.movePosition(Document doc, Node node, Offset newPos, [Offset oldPos]) {
    final nodeId = node.id;
    return Command(
      oldPos ?? node.position,
      () {
        doc.findNode(nodeId).position = newPos;
      },
      (oldPosition) {
        doc.findNode(nodeId).position = oldPosition as Offset;
      },
    );
  }

  factory Command.connect(Document doc, Node parent, Node node, ChildSlot slot) {
    final parentId = parent.id;
    final nodeId = node.id;
    final addNewSlot = [
      RootNode.addCallChildSlot,
      RootNode.addStreamChildSlot,
      Node.addChildSlot,
    ].contains(slot);
    return Command(
      nodeId,
      () {
        doc.connectNode(
          parent: doc.findNode(parentId),
          child: doc.findNode(nodeId),
          slotId: slot?.id,
        );
      },
      (_) {
        doc.disconnectNode(
          parent: doc.findNode(parentId),
          childId: nodeId,
          deleteSlot: addNewSlot,
        );
      },
    );
  }

  factory Command.disconnect(Document doc, Node parent, ChildSlot slot) {
    final parentId = parent.id;
    final childId = slot.childId;
    final slotId = slot.id;
    return Command(
      slot.childId,
      () {
        doc.disconnectNode(
          parent: doc.findNode(parentId),
          childId: childId,
        );
      },
      (_) {
        final child = doc.findNode(childId);
        doc.connectNode(
          parent: doc.findNode(parentId),
          child: child,
          slotId: slotId,
        );
      },
    );
  }

  factory Command.disconnectParent(Document doc, Node node) {
    final nodeId = node.id;
    final parents = doc.parentsOf(node);
    final slotIds = {for (var parent in parents) parent.id: parent.slotIdForChild(node)};
    return Command(
      slotIds,
      () {
        doc.disconnectNodeFromParent(doc.findNode(nodeId));
      },
      (parents) {
        final node = doc.findNode(nodeId);
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
    final nodeId = node.id;
    final slotIds = {for (var n in node.children) n.id: node.slotIdForChild(n)};
    return Command(
      slotIds,
      () {
        doc.disconnectAllChildren(doc.findNode(nodeId));
      },
      (childIds) {
        final node = doc.findNode(nodeId);
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

  factory Command.renameSlot(Document doc, Node node, ChildSlot slot, String name) {
    final nodeId = node.id;
    return Command(
      slot.name,
      () {
        doc.findNode(nodeId).renameSlot(slot.id, name);
      },
      (oldName) {
        doc.findNode(nodeId).renameSlot(slot.id, oldName as String);
      },
    );
  }

  factory Command.addSlot(Document doc, Node node, String name) {
    final nodeId = node.id;
    String slotId;
    return Command(
      node.id,
      () {
        slotId = doc.findNode(nodeId).addSlot('new child').id;
      },
      (_) {
        doc.findNode(nodeId).removeSlot(slotId);
      },
    );
  }

  factory Command.addCallSlot(Document doc, RootNode root) {
    String slotId;
    return Command(
      root.id,
      () {
        slotId = root.addCallSlot().id;
      },
      (_) {
        root.removeSlot(slotId);
      },
    );
  }

  factory Command.addStreamSlot(Document doc, RootNode root) {
    String slotId;
    return Command(
      root.id,
      () {
        slotId = root.addStreamSlot().id;
      },
      (_) {
        root.removeSlot(slotId);
      },
    );
  }

  factory Command.deleteSlot(Document doc, Node node, ChildSlot slot) {
    final nodeId = node.id;
    final childId = slot.childId;
    final slotId = slot.id;
    String serializedSlot;
    final slotIndex = node.indexOfSlot(slot);
    var isCallSlot = false;
    if (node is RootNode) {
      isCallSlot = node.isCallSlot(slot);
    }
    return Command(
      childId,
      () {
        if (childId != null) {
          doc.disconnectNode(parent: doc.findNode(nodeId), childId: childId);
        }
        serializedSlot = jsonEncode(slot);
        node.removeSlot(slotId);
      },
      (childId) {
        final node = doc.findNode(nodeId);
        final slot = ChildSlot.fromJson(jsonDecode(serializedSlot));
        if (node is RootNode) {
          if (isCallSlot) {
            node.attachCallSlot(slot, slotIndex);
          } else {
            node.attachStreamSlot(slot, slotIndex);
          }
        } else {
          node.attachSlot(slot, slotIndex);
        }
        if (childId != null) {
          final child = doc.findNode(childId as String);
          doc.connectNode(parent: node, child: child, slotId: slotId);
        }
      },
    );
  }

  factory Command.flatten(Document doc, Selection selection, PrefabNode node) {
    final nodeId = node.id;
    String serializedFlattened;
    return Command(
      jsonEncode(node),
      () {
        final flattened = doc.flattenPrefabNode(doc.findNode(nodeId));
        selection.select(flattened.first);
        serializedFlattened = jsonEncode(flattened);
      },
      (serializedNode) {
        final json = jsonDecode(serializedNode as String);
        final node = Node.fromJson(json);
        doc.addNode(node);
        selection.select(node);

        List<Object> flattenedJson = jsonDecode(serializedFlattened);
        final flattened = flattenedJson.map((j) {
          final n = Node.fromJson(j);
          n.setDocDeep(doc);
          return n;
        }).toList();
        final firstFlattened = flattened.first;
        final parents = doc.parentsOf(firstFlattened);
        if (parents.isNotEmpty) {
          for (final parent in parents) {
            parent.replaceChild(firstFlattened.id, node);
          }
        }

        for (final n in flattened) {
          doc.deleteNodeAndDescendants(n);
        }
      },
    );
  }

  factory Command.autoLayout(Document doc, AstNode node) {
    final nodeId = node.id;
    final positions = {for (var n in node.nodes) n.id: n.position};
    return Command(
      positions,
      () {
        (doc.findNode(nodeId) as AstNode).autoLayout();
        doc.forceRedraw();
      },
      (oldPositions) {
        final node = doc.findNode(nodeId);
        final positions = oldPositions as Map<String, Offset>;
        for (final n in node.nodes) {
          n.position = positions[n.id];
        }
        doc.forceRedraw();
      },
    );
  }
}
