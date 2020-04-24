import 'package:flutter/material.dart';
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
  final Stream stream;
  final Call call;
  AstNode(this.value, {this.stream, this.call});

  Value node() {
    if (call != null) {
      return call.result;
    }
    if (stream != null) {
      return stream.filter;
    }
    return value;
  }

  String title() {
    if (call != null) {
      return call.name;
    }
    if (stream != null) {
      return stream.name;
    }

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

final double nodeVerticalMargin = 10;

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
    margin: EdgeInsets.all(nodeVerticalMargin),
  );
}

Widget nodeShape(String label, [Color decorationColor = Colors.white]) {
  return Container(
    constraints: BoxConstraints(maxWidth: 200),
    decoration: BoxDecoration(
      color: decorationColor,
      border: Border.all(color: Colors.black, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(label),
    ),
    margin: EdgeInsets.all(nodeVerticalMargin),
  );
}

class RootNodeView extends StatelessWidget {
  final AstRoot root;
  RootNodeView(this.root);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
                    .map((e) => NodeView(AstNode(null, stream: e)))
                    .toList(),
              ),
            ]),
            Column(children: [
              nodeShape('calls'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: root.astRoot.calls
                    .map((e) => NodeView(AstNode(null, call: e)))
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
  final List<Offset> _edgeEnds = [];
  Future<List<Offset>> _edgesCalculation;

  _NodeViewState(this.node);

  @override
  void initState() {
    _edgesCalculation = Future<List<Offset>>.delayed(Duration(milliseconds: 20), () => _edgeEnds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);

    return Stack(
      children: [
        FutureBuilder<List<Offset>>(
          future: _edgesCalculation,
          builder: (BuildContext context, AsyncSnapshot<List<Offset>> snapshot) {
            if (snapshot.hasData) {
              return CustomPaint(
                painter: EdgePainter(snapshot.data),
              );
            }
            return SizedBox();
          }
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            node.value == null ? branchShape(node.title()) : nodeShape(node.title()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: node.node().children.map((e) {
                final childView = NodeView(
                  AstNode(e),
                  key: GlobalKey(),
                );
                _childKeys.add(childView.key);
                return childView;
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  void postFrameCallback(_) {
    final insideVerticalOffset = 15;
    List<Offset> ends = _childKeys.map((e) {
      var childContext = e.currentContext;
      if (childContext == null) {
        return null;
      }
      var renderedObject = childContext.findRenderObject() as RenderBox;
      var pos = renderedObject.localToGlobal(Offset.zero, ancestor: this.context.findRenderObject());
      return Offset(pos.dx + childContext.size.width / 2, pos.dy + nodeVerticalMargin + insideVerticalOffset);
    }).where((w) => w != null).toList();
    _edgeEnds.clear();
    // Add current node's center point as edges' start.
    _edgeEnds.add(Offset(context.size.width / 2, nodeVerticalMargin + insideVerticalOffset));
    _edgeEnds.addAll(ends);
  }
}

class EdgePainter extends CustomPainter {
  final List<Offset> points; // First one is start, the others ends.
  EdgePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final start = points.first;
    for (var point in points.sublist(1)) {
      canvas.drawLine(start, point, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CanvasLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[300],
    );
  }
}
