import 'package:flutter/material.dart';

import 'models/graph.dart';
import 'models/editor_bag.dart';
import 'object_panel.dart';

class Editor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditorState();
  }
}

class _EditorState extends State<Editor> {
  final double objectPanelWidth = 240;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, constraints) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: objectPanelWidth,
            right: 0,
            bottom: 0,
            child: DesignEditor(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: constraints.maxWidth - objectPanelWidth,
            bottom: 0,
            child: ObjectPanel(),
          ),
        ],
      );
    });
  }
}

class DesignEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DesignEditorState();
  }
}

class _DesignEditorState extends State<DesignEditor> {
  final double _canvasMargin = 20;
  Offset canvasOffset = Offset.zero;
  final List<Graph> graphs = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey[400],
        ),
        Positioned(
          left: _canvasMargin + canvasOffset.dx,
          top: _canvasMargin + canvasOffset.dy,
          right: _canvasMargin - canvasOffset.dx,
          bottom: _canvasMargin - canvasOffset.dy,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
        Listener(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: CustomPaint(
              painter: _DesignCanvasPainter(canvasOffset, graphs),
              child: Container(),
            ),
          ),
          onPointerMove: onPointerMove,
          onPointerUp: onPointerUp,
        ),
        DragTarget<String>(
          onWillAccept: onDragWillAccept,
          onAccept: onDragAccept,
          builder: (context, candidateData, rejectedData) => Container(),
        ),
      ],
    );
  }

  bool onDragWillAccept(String data) {
    print('data = $data onWillAccept');
    return data != null;
  }

  void onDragAccept(String data) {
    // Draggable.onDragEnd gets called after DragTarget.onDragAccept. That
    // doesn't leave us the proper drop position.
    // Note flutter already has a PR to include the offset for onDragAccept.
    Future.delayed(Duration(milliseconds: 20), () {
      final renderBox = context.findRenderObject() as RenderBox;
      final pos = renderBox.globalToLocal(editorBag.lastDropOffset) - canvasOffset;
      setState(() {
        graphs.add(Graph(pos));
      });
    });
  }

  void onPointerMove(PointerMoveEvent event) {
    setState(() {
      canvasOffset += event.delta;
    });
  }

  void onPointerUp(PointerUpEvent event) {
    print('on pointer up');
  }
}

class _DesignCanvasPainter extends CustomPainter {
  final Offset offset;
  final List<Graph> graphs;

  _DesignCanvasPainter(this.offset, this.graphs);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1;

    for (var graph in graphs) {
      canvas.drawCircle(offset + graph.pos, 30, paint);
    }
  }

  @override
  bool shouldRepaint(_DesignCanvasPainter oldPainter) {
    return offset != oldPainter.offset || graphs != oldPainter.graphs;
  }
}
