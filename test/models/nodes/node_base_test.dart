import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/nodes/node_base.dart';

class _SomeNode extends Node {
  @override
  int get minimumSlotCount => 2;
  @override
  int get maximumSlotCount => 3;
}

class _SingleNode extends Node {
  @override
  int get minimumSlotCount => 0;
  @override
  int get maximumSlotCount => 0;
}

void main() {
  group('child slot', () {
    test('is connected', () {
      var slot = ChildSlot();
      expect(slot.isConnected, false);
      slot.childId = Node().id;
      expect(slot.isConnected, true);
    });
  });

  test('equality', () {
    final one = Node();
    final two = Node();
    expect(one == one, true);
    expect(one == two, false);
    expect(one == null, false);
    // ignore: unrelated_type_equality_checks
    expect(one == 0, false);

    Node nullNode;
    expect(nullNode == null, true);
  });

  test('can add or remove slot', () {
    final node = _SomeNode();

    node.addSlot('first');
    node.addSlot('second');
    expect(node.canAddSlot, true);
    final last = node.addSlot('last');
    expect(node.canAddSlot, false);
    expect(node.canRemoveSlot, true);
    node.removeSlot(last.id);
    expect(node.canRemoveSlot, false);
  });

  test('add child', () {
    final parent = Node();
    final child = Node();
    parent.addChild(child);
    expect(parent.children.contains(child), true);
    expect(parent.children.length, 1);

    parent.addChild(Node());
    expect(parent.children.length, 2);

    parent.addChild(child); // no re-entry
    expect(parent.children.length, 2);
  });

  test('remove child', () {
    final node = Node();
    final slot = node.addSlot('first');
    final child = Node();
    node.addChild(child, slot.id);
    expect(slot.childId, child.id);
    node.removeChild(child.id);
    expect(slot.childId, null);
  });

  test('add slot when children are added', () {
    final node = Node();
    final slot = node.addSlot('first');
    node.addChild(Node(), slot.id);
    expect(node.slots.length, 1);
    node.addChild(Node(), Node.addChildSlot.id);
    expect(node.slots.length, 2);

    expect(() {
      node.addChild(Node(), ChildSlot().id);
    }, throwsA(isA<AssertionError>()));
  });

  test('child is removed when its slot is removed', () {
    final node = Node();
    final slot = node.addSlot('first');
    final child = Node();
    node.addChild(child, slot.id);
    expect(node.children.contains(child), true);
    node.removeSlot(slot.id);
    expect(node.children.contains(child), false);
  });

  group('get nodes', () {
    test('single node', () {
      final node = Node();
      expect(node.nodes, [node]);
    });

    test('tree', () {
      final parent = Node();
      final child1 = Node();
      parent.addChild(child1);
      final grandson = Node();
      child1.addChild(grandson);
      final child2 = Node();
      parent.addChild(child2);

      final nodes = parent.nodes;

      for (final node in [parent, child1, child2, grandson]) {
        expect(nodes, contains(node));
      }
    });
  });

  test('child connector position', () {
    final node = Node();
    final child1 = Node(), child2 = Node();
    var child1Slot = node.addSlot('child1');
    child1Slot.childId = child1.id;
    var child2Slot = node.addSlot('child2');
    child2Slot.childId = child2.id;

    expect(node.childConnectorPosition(child1), node.slotConnectorPosition(child1Slot));
    expect(node.childConnectorPosition(child2), node.slotConnectorPosition(child2Slot));
  });

  group('slot connector position and hittest', () {
    test("slot not from node can't get position", () {
      final node = Node();
      expect(node.slotConnectorPosition(ChildSlot()), null);
    });

    test('hittest position outside/inside the node', () {
      final node = Node();
      expect(node.hitTest(Offset(0, -1)), null);
      expect(node.hitTest(Offset(-1, 0)), null);
      expect(node.hitTest(Offset(node.size.width, node.size.width + 1)), null);
      expect(node.hitTest(Offset(node.size.width + 1, node.size.width)), null);
    });

    test('on first slot connector', () {
      final node = Node();
      final child = Node();
      var slot = node.addSlot('');
      final pos = node.slotConnectorPosition(slot) - node.position;
      expect(node.hitTest(pos), slot);
      slot.childId = child.id;
      expect(node.hitTest(pos), null);
    });
    test('on second slot connector', () {
      final node = Node();
      final child = Node();
      node.addSlot('');
      var slot = node.addSlot('');
      final pos = node.slotConnectorPosition(slot) - node.position;
      expect(node.hitTest(pos), slot);
      slot.childId = child.id;
      expect(node.hitTest(pos), null);
    });

    test('on add child button', () {
      final node = Node();
      final pos = node.slotConnectorPosition(Node.addChildSlot) - node.position;
      expect(node.hitTest(pos), Node.addChildSlot);
    });

    test('no add child button', () {
      final node = _SingleNode();
      final pos = node.slotConnectorPosition(Node.addChildSlot) - node.position;
      expect(node.hitTest(pos), null);
    });
  });
}
