import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:convert/convert.dart';

import 'protos/ast.pb.dart';
import 'ast_example.dart';

class AstRoot {
  final String name;
  final Root astRoot;
  AstRoot(this.name, this.astRoot);
}

class AstNode {
  final Value value;
  AstNode(this.value);

  String title() {
    String type = value.t.toString();
    if (value.hasU()) {
      return '$type(${value.u.toString()})';
    }

    if (value.hasRaw()) {
      return '$type(0x${hex.encode(value.raw)})';
    }

    return type;
  }
}

class AstTreePage extends StatelessWidget {
  final AstRoot astRoot =
      AstRoot('balance', buildRoot('balance', executionNode(queryCellNode())));

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CanvasLayer(),
          NodesLayer(astRoot),
        ],
      ),
    );
  }
}

class NodesLayer extends StatelessWidget {
  final AstRoot astRoot;
  NodesLayer(this.astRoot);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RootNodeView(astRoot),
    );
  }
}

Widget branchShape(String label) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(label),
    ),
    margin: EdgeInsets.all(10),
  );
}

Widget nodeShape(String label, [Color decorationColor = Colors.white]) {
  return Container(
    decoration: BoxDecoration(
      color: decorationColor,
      border: Border.all(color: Colors.black, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(label),
    ),
    margin: EdgeInsets.all(10),
  );
}

// A call or stream view.
Widget branchView(String name, Value node) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      branchShape(name),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: node.children.map((e) => NodeView(AstNode(e))).toList(),
      ),
    ],
  );
}

class RootNodeView extends StatelessWidget {
  final AstRoot root;
  RootNodeView(this.root);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        nodeShape(root.name, Colors.blue[100]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              nodeShape('streams'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: root.astRoot.streams
                    .map((e) => branchView(e.name, e.filter))
                    .toList(),
              ),
            ]),
            Column(children: [
              nodeShape('calls'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: root.astRoot.calls
                    .map((e) => branchView(e.name, e.result))
                    .toList(),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}

class NodeView extends StatefulWidget {
  final AstNode node;

  const NodeView(this.node, {
    Key key,
  }) : super(key: key);

  @override
  _NodeViewState createState() {
    return _NodeViewState(node);
  }
}

class _NodeViewState extends State<NodeView> {
  final AstNode node;
  final List<GlobalKey> _childKeys = [];

  _NodeViewState(this.node);

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        nodeShape(node.title()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: node.value.children.map((e) {
            final childView = NodeView(
              AstNode(e),
              key: GlobalKey(),
            );
            _childKeys.add(childView.key);
            return childView;
          }).toList(),
        ),
      ],
    );
  }

  void postFrameCallback(_) {
    List<Widget> edges = _childKeys.map((e) {
      var context = e.currentContext;
      var renderedObject = context.findRenderObject() as RenderBox;
      var pos = renderedObject.localToGlobal(Offset.zero);
      print('pos: (${pos.dx}, ${pos.dy})');
      print('size: (${context.size.width}, ${context.size.height})');
      return Positioned(
        left: pos.dx,
        top: pos.dy,
        child: Text('edges'),
      );
    }).toList();

    var edgesOverlay = OverlayEntry(builder: (context) {
      return Stack(
        children: edges,
      );
    });

    Overlay.of(context).insert(edgesOverlay);
  }
}

class CanvasLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[300],
    );
  }
}
