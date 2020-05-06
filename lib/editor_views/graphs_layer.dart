import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/document.dart';
import '../models/selection.dart';
import '../models/editor_state.dart';

import '../node_views/node_view.dart';
import '../utils/edge_path.dart';

class GraphsLayer extends StatefulWidget {
  @override
  _GraphsLayerState createState() => _GraphsLayerState();
}

class _GraphsLayerState extends State<GraphsLayer> {
  bool _isDragging = false;
  bool _isDraggingCanvas = false;
  bool _isDraggingConnector = false;
  Offset _startConnectorOffset, _endConnectorOffset;

  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);
    final selection = Provider.of<Selection>(context);
    final editorState = Provider.of<EditorState>(context, listen: false);

    final nodeViews = document.nodes.map((e) {
      return NodeView(e, selection);
    }).toList();

    final hitTest = (Offset point) {
      for (final nodeView in nodeViews.reversed) {
        final rect = Rect.fromLTWH(
          nodeView.node.position.dx,
          nodeView.node.position.dy,
          nodeView.size.width,
          nodeView.size.height,
        );
        if (rect.contains(point)) {
          return nodeView.node;
        }
      }
      return null;
    };

    return Listener(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: <Widget>[...nodeViews, ConnectingNodesView(_startConnectorOffset, _endConnectorOffset)],
      ),
      onPointerMove: (event) {
        // HisTest and move objects. Note: inner listener cannot stop  outer
        // listener; nested listeners won't work.
        // On the other side, GestureDetector has a delay which makes dragging
        // feel unnatural.
        if (!_isDragging) {
          final node = hitTest(event.localPosition);
          selection.select(node);
          _isDraggingCanvas = node == null;
          _isDragging = true;
          _isDraggingConnector = true; // TODO: hittest
          _startConnectorOffset = _endConnectorOffset = event.localPosition;
        }

        if (_isDraggingCanvas) {
          editorState.moveCanvas(event.delta);
        } else if (_isDraggingConnector) {
          final target = hitTest(event.localPosition);
          selection.hover(target);
          setState(() {
            _endConnectorOffset += event.delta;
          });
        } else {
          document.moveNodePosition(
            selection.selectedNode(document.nodes),
            event.delta / editorState.zoomScale,
          );
        }
      },
      onPointerDown: (event) {
        final node = hitTest(event.localPosition);
        selection.select(node);
      },
      onPointerUp: (event) {
        _isDragging = false;
        _isDraggingCanvas = false;

        if (_isDraggingConnector) {
          final target = hitTest(event.localPosition);
          if (target != null && target != selection.selectedNode(document.nodes)) {
            selection.select(target);
            // TODO: process connecting
          }
          selection.hover(null);
          setState(() {});
        }

        _isDraggingConnector = false;
        _startConnectorOffset = _endConnectorOffset = null;
      },
    );
  }
}

class ConnectingNodesView extends StatelessWidget {
  final Offset start, end;
  ConnectingNodesView(this.start, this.end);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConnectingNodesPainter(start, end),
      child: Container(),
    );
  }
}

class _ConnectingNodesPainter extends CustomPainter {
  final Offset start, end;
  _ConnectingNodesPainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null && end == null) {
      return;
    }

    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = Colors.red[400];

    final path = EdgePath(start, end).path;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ConnectingNodesPainter old) => false;
}
