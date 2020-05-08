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

    final hitTest = (Offset point) {
      for (final node in document.nodes.reversed) {
        final rect = Rect.fromLTWH(
          node.position.dx,
          node.position.dy,
          node.size.width,
          node.size.height,
        );
        if (rect.contains(point)) {
          return node;
        }
      }
      return null;
    };

    final nodeViews = document.nodes.map((e) => NodeView(e, selection)).toList();

    return Listener(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: <Widget>[
          ...nodeViews,
          ConnectingNodesView(_startConnectorOffset, _endConnectorOffset)
        ],
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
          _isDraggingConnector = false; // TODO: hittest
          _startConnectorOffset = _endConnectorOffset = event.localPosition;
        }

        if (_isDraggingCanvas) {
          editorState.moveCanvas(event.delta);
        } else if (_isDraggingConnector) {
          final source = selection.selectedNode(document.nodes);
          final target = hitTest(event.localPosition);
          if (document.canConnect(parent: source, child: target)) {
            selection.hover(target);
          }
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
          final source = selection.selectedNode(document.nodes);
          final target = hitTest(event.localPosition);
          if (document.canConnect(parent: source, child: target)) {
            document.connectNode(parent: source, child: target);
            selection.select(target);
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
    /// This view only draws the dragging connector to link nodes.
    /// It should not eat any mouse event itself.
    return IgnorePointer(
      child: CustomPaint(
        painter: _ConnectingNodesPainter(start, end),
        child: Container(),
      ),
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
