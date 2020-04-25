import 'package:flutter/material.dart';
import 'package:convert/convert.dart';

import 'protos/ast.pb.dart';
import 'ast_example.dart';

class AstNode {
  String get name => throw UnimplementedError;
  List<AstNode> get children => throw UnimplementedError;
}

class AstRoot extends AstNode {
  final String name;
  final Root root;
  AstRoot(this.name, this.root);

  @override
  List<AstNode> get children {
    return [
      AstStreams(root.streams),
      AstCalls(root.calls),
    ];
  }
}

class AstStreams extends AstNode {
  final List<Stream> streams;
  AstStreams(this.streams);

  @override
  String get name => 'streams';

  @override
  List<AstNode> get children => streams.map((e) => AstStream(e)).toList();
}

class AstStream extends AstNode {
  final Stream stream;
  AstStream(this.stream);

  @override
  String get name => stream.name;

  @override
  List<AstNode> get children => [AstValue(stream.filter)];
}

class AstCalls extends AstNode {
  final List<Call> calls;
  AstCalls(this.calls);

  @override
  String get name => 'calls';

  @override
  List<AstNode> get children => calls.map((e) => AstCall(e)).toList();
}

class AstCall extends AstNode {
  final Call call;
  AstCall(this.call);

  @override
  String get name => call.name;

  @override
  List<AstNode> get children => [AstValue(call.result)];
}

class AstValue extends AstNode {
  final Value value;
  AstValue(this.value);

  @override
  String get name {
    String type = value.t.toString();
    if (value.hasU()) {
      return '$type(${value.u.toString()})';
    }

    if (value.hasRaw()) {
      return '$type(0x${hex.encode(value.raw)})';
    }

    return type;
  }

  @override
  List<AstNode> get children => value.children.map((e) => AstValue(e)).toList();
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
          Container(color: Colors.blue[300]),
          NodeView(astRoot),
        ],
      ),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (node is AstStream || node is AstCall) ? branchShape(node.name) : nodeShape(node.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: node.children.map((child) {
                final childView = NodeView(
                  child,
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
    List<Offset> ends = _childKeys.where((e) => e.currentContext != null).map((e) {
      var childContext = e.currentContext;
      var renderedObject = childContext.findRenderObject() as RenderBox;
      var pos = renderedObject.localToGlobal(Offset.zero, ancestor: this.context.findRenderObject());
      return Offset(pos.dx + childContext.size.width / 2, pos.dy + nodeVerticalMargin + insideVerticalOffset);
    }).toList();
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
