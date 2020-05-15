import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';
import '../../models/editor_state.dart';

import '../../utils/edge_path.dart';

/// Handles mouse events for moving canvas or nodes around, connecting
/// nodes as parent/child and accepts object library drag target.
class PointerLayer extends StatefulWidget {
  @override
  _PointerLayerState createState() => _PointerLayerState();
}

class _PointerLayerState extends State<PointerLayer> {
  bool _isDragging = false;
  bool _isDraggingCanvas = false;
  bool _isDraggingConnector = false;
  Offset _startConnectorOffset, _endConnectorOffset;

  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context, listen: false);
    final selection = Provider.of<Selection>(context, listen: false);
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

    return Listener(
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: <Widget>[
          DragTarget<NodeTemplate>(
            onWillAccept: (data) => data != null,
            onAcceptWithDetails: (details) {
              final renderBox = context.findRenderObject() as RenderBox;
              final pos = renderBox.globalToLocal(details.offset);
              final node = NodeCreator.create(details.data, pos);
              document.addNode(node);
              selection.select(node);
            },
            builder: (context, candidateData, rejectedData) => Container(),
          ),
          if (_isDraggingConnector) ConnectingNodesView(_startConnectorOffset, _endConnectorOffset)
        ],
      ),
      onPointerMove: (event) {
        // HisTest and move objects. Note: inner listener cannot stop  outer
        // listener; nested listeners won't work.
        // On the other side, GestureDetector has a delay which makes dragging
        // feel unnatural.
        if (!_isDragging) {
          _isDragging = true;
          final node = hitTest(event.localPosition);
          selection.select(node);
          if (node == null) {
            _isDraggingCanvas = true;
          } else {
            _isDraggingCanvas = false;
            final slot = node.hitTest(event.localPosition - node.position);
            if (slot != null) {
              _isDraggingConnector = true;
              _startConnectorOffset = node.slotConnectorPosition(slot);
              _endConnectorOffset = event.localPosition;
            }
          }
        }

        if (_isDraggingCanvas) {
          editorState.moveCanvas(event.delta);
        } else if (_isDraggingConnector) {
          final source = selection.selectedNode(document.nodes);
          final target = hitTest(event.localPosition);
          if (document.canConnect(parent: source, child: target)) {
            selection.hover(target);
          } else {
            selection.hover(null);
          }
          setState(() {
            _endConnectorOffset += event.delta / editorState.zoomScale;
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
          final slot = source.hitTest(_startConnectorOffset - source.position);
          final target = hitTest(event.localPosition);
          if (document.canConnect(parent: source, child: target)) {
            document.connectNode(parent: source, child: target, slot_id: slot?.id);
            // selection.select(target);
          }
          selection.hover(null);
          _startConnectorOffset = _endConnectorOffset = null;
          _isDraggingConnector = false;
          setState(() {});
        }
      },
    );
  }
}

/// Draw a link from parent node to child node.
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
    if (start == null || end == null) {
      return;
    }

    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.red[400];

    canvas.drawCircle(start, 6, paint);

    final path = EdgePath(start + Offset(6, 0), end).path;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ConnectingNodesPainter old) {
    return old.start != start || old.end != end;
  }
}
