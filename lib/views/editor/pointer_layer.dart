import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';
import '../../models/editor_state.dart';

import '../../utils/edge_path.dart';

import '../../context_menu.dart';

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
  bool _isShowingContextMenu = false;
  Offset _contentMenuOffset;
  Offset _startConnectorOffset, _endConnectorOffset;

  Document get document => Provider.of<Document>(context, listen: false);
  Selection get selection => Provider.of<Selection>(context, listen: false);
  EditorState get editorState => Provider.of<EditorState>(context, listen: false);

  @override
  Widget build(BuildContext context) {
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
          if (_isDraggingConnector)
            ConnectingNodesView(
              _startConnectorOffset,
              _endConnectorOffset,
            ),
          if (_isShowingContextMenu)
            Positioned(
              left: _contentMenuOffset.dx,
              top: _contentMenuOffset.dy,
              child: Transform(
                transform: Matrix4.translationValues(1, 1, 0)
                  ..scale(1 / editorState.zoomScale, 1 / editorState.zoomScale, 1),
                child: ContextMenu(
                  NodeActionBuilder(
                    document,
                    selection.selectedNode(document.nodes),
                  ).build(),
                  _handleActionItem,
                ),
              ),
            ),
        ],
      ),
      onPointerMove: _onPointerMove,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
    );
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_isDragging) {
      _isDragging = true;
      final node = _hitTest(event.localPosition);
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
      final target = _hitTest(event.localPosition);
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
  }

  void _onPointerDown(PointerDownEvent event) {
    final node = _hitTest(event.localPosition);
    if (node != null) {
      selection.select(node);
    }

    if (node != null && event.buttons & kSecondaryMouseButton == kSecondaryMouseButton) {
      var menuOffset = event.localPosition;
      final size = menuSize();
      if (context.size.width <= size.width || context.size.height <= size.height) {
        // If canvas size is too small don't bother showing the context menu
        return;
      }

      if (menuOffset.dx + size.width > context.size.width) {
        menuOffset -= Offset(size.width, 0);
      }
      if (menuOffset.dy + size.height > context.size.height) {
        menuOffset -= Offset(0, size.height);
      }
      setState(() {
        _isShowingContextMenu = node is AstNode;
        _contentMenuOffset = menuOffset;
      });
    } else {
      /// Do not rebuild immediately. This allows the button/action inside the context menu
      /// to have enough time to respond if user clicks an menu item.
      if (_isShowingContextMenu) {
        if (!menuSize().contains(event.localPosition - _contentMenuOffset)) {
          // Not clicking menu items.
          setState(() {
            _isShowingContextMenu = false;
          });
        }
      } else {
        if (node == null) {
          selection.select(null);
        }
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _isDragging = false;
    _isDraggingCanvas = false;

    if (_isDraggingConnector) {
      final source = selection.selectedNode(document.nodes);
      final slot = source.hitTest(_startConnectorOffset - source.position);
      final target = _hitTest(event.localPosition);
      if (document.canConnect(parent: source, child: target)) {
        document.connectNode(parent: source, child: target, slot_id: slot?.id);
        // selection.select(target);
      }
      selection.hover(null);
      _startConnectorOffset = _endConnectorOffset = null;
      _isDraggingConnector = false;
      setState(() {});
    }
  }

  Node _hitTest(Offset point) {
    for (final node in document.nodes.reversed) {
      if (node.size.contains(point - node.position)) {
        return node;
      }
    }
    return null;
  }

  void _handleActionItem(NodeActionItem item) {
    // TODO: handle
    print('NodeActionItem ${item.value.toString()} clicked');
    setState(() {
      _isShowingContextMenu = false;
    });
  }

  Size menuSize() {
    final actions = NodeActionBuilder(
      document,
      selection.selectedNode(document.nodes),
    ).build();

    /// Context menu should not zoom with canvas
    return ContextMenu.sizeFor(actions) / editorState.zoomScale;
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