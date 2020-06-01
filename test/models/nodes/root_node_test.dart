import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/node.dart';

void main() {
  test('dynamic size based on count of calls and streams', () {
    final node = RootNode();
    var size = node.size;
    node.addCallSlot();
    expect(node.size.height, greaterThan(size.height));
    size = node.size;
    node.addStreamSlot();
    expect(node.size.height, greaterThan(size.height));
    size = node.size;
    node.addChild(Node(), RootNode.addCallChildSlot.id);
    expect(node.size.height, greaterThan(size.height));
    size = node.size;
    node.addChild(Node(), RootNode.addStreamChildSlot.id);
    expect(node.size.height, greaterThan(size.height));
  });

  test('add call slot', () {
    final node = RootNode();
    expect(node.callSlots.length, 0);
    node.addCallSlot();
    expect(node.callSlots.length, 1);
    expect(node.slots.length, 1);
  });

  test('add stream slot', () {
    final node = RootNode();
    expect(node.streamSlots.length, 0);
    node.addStreamSlot();
    expect(node.streamSlots.length, 1);
    expect(node.slots.length, 1);
  });

  test('add call and stream slots', () {
    final node = RootNode();
    node.addCallSlot();
    node.addStreamSlot();
    expect(node.slots.length, 2);
  });

  test('remove call and stream slots', () {
    final node = RootNode();
    final callSlot = node.addCallSlot();
    final streamSlot = node.addStreamSlot();
    node.removeSlot(callSlot.id);
    expect(node.callSlots.length, 0);
    expect(node.slots.length, 1);
    node.removeSlot(streamSlot.id);
    expect(node.streamSlots.length, 0);
    expect(node.slots.length, 0);
  });

  test('add call child', () {
    final node = RootNode();
    final callSlot = node.addCallSlot();
    final call = Node();
    node.addChild(call, callSlot.id);
    expect(node.callSlots.length, 1);
    expect(node.callSlots[0].childId, call.id);

    final anotherCall = Node();
    node.addChild(anotherCall, RootNode.addCallChildSlot.id);
    expect(node.callSlots.length, 2);
    expect(node.callSlots[1].childId, anotherCall.id);
  });

  test('add stream child', () {
    final node = RootNode();
    final streamSlot = node.addStreamSlot();
    final stream = Node();
    node.addChild(stream, streamSlot.id);
    expect(node.streamSlots.length, 1);
    expect(node.streamSlots[0].childId, stream.id);

    final anotherStream = Node();
    node.addChild(anotherStream, RootNode.addStreamChildSlot.id);
    expect(node.streamSlots.length, 2);
    expect(node.streamSlots[1].childId, anotherStream.id);
  });

  test('child connector position', () {
    final node = RootNode();
    final call = Node(), stream = Node();
    node.addCallSlot();
    var callSlot = node.addCallSlot();
    callSlot.childId = call.id;
    node.addCallSlot();
    node.addStreamSlot();
    var streamSlot = node.addStreamSlot();
    streamSlot.childId = stream.id;
    node.addStreamSlot();

    expect(node.childConnectorPosition(call), node.slotConnectorPosition(callSlot));
    expect(node.childConnectorPosition(stream), node.slotConnectorPosition(streamSlot));
  });

  group('slot connector position and hittest', () {
    test("slot not from node can't get position", () {
      final node = RootNode();
      expect(node.slotConnectorPosition(ChildSlot()), null);
    });

    test('hittest position outside/inside the node', () {
      final node = RootNode();
      expect(node.hitTest(Offset(0, -1)), null);
      expect(node.hitTest(Offset(-1, 0)), null);
      expect(node.hitTest(Offset(node.size.width, node.size.width + 1)), null);
      expect(node.hitTest(Offset(node.size.width + 1, node.size.width)), null);
    });

    test('on first call slot connector', () {
      final node = RootNode();
      final child = Node();
      var slot = node.addCallSlot();
      final pos = node.slotConnectorPosition(slot) - node.position;
      expect(node.hitTest(pos), slot);
      slot.childId = child.id;
      expect(node.hitTest(pos), null);
    });
    test('on second call slot connector', () {
      final node = RootNode();
      final child = Node();
      node.addCallSlot();
      var slot = node.addCallSlot();
      final pos = node.slotConnectorPosition(slot) - node.position;
      expect(node.hitTest(pos), slot);
      slot.childId = child.id;
      expect(node.hitTest(pos), null);
    });

    test('on add call button', () {
      final node = RootNode();
      final pos = node.slotConnectorPosition(RootNode.addCallChildSlot) - node.position;
      expect(node.hitTest(pos), RootNode.addCallChildSlot);
    });

    test('on first stream slot connector', () {
      final node = RootNode();
      final child = Node();
      var slot = node.addStreamSlot();
      final pos = node.slotConnectorPosition(slot) - node.position;
      expect(node.hitTest(pos), slot);
      slot.childId = child.id;
      expect(node.hitTest(pos), null);
    });
    test('on second stream slot connector', () {
      final node = RootNode();
      final child = Node();
      node.addStreamSlot();
      var slot = node.addStreamSlot();
      final pos = node.slotConnectorPosition(slot) - node.position;
      expect(node.hitTest(pos), slot);
      slot.childId = child.id;
      expect(node.hitTest(pos), null);
    });
    test('on stream slot connector with call slot', () {
      final node = RootNode();
      final child = Node();
      node.addCallSlot();
      node.addStreamSlot();
      var slot = node.addStreamSlot();
      final pos = node.slotConnectorPosition(slot) - node.position;
      expect(node.hitTest(pos), slot);
      slot.childId = child.id;
      expect(node.hitTest(pos), null);
    });

    test('on add stream button', () {
      final node = RootNode();
      final pos = node.slotConnectorPosition(RootNode.addStreamChildSlot) - node.position;
      expect(node.hitTest(pos), RootNode.addStreamChildSlot);
    });
  });
}
