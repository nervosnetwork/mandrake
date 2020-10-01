import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';
import '../../models/editor_state.dart';
import '../../models/command.dart';

import 'edge_path.dart';
import '../../utils/focus_helper.dart';

import 'editor_dimensions.dart';
import '../../widgets/context_menu.dart';

/// Handles mouse events for moving canvas or nodes around, connecting
/// nodes as parent/child and accepts object library drag target.
class PointerLayer extends StatefulWidget {
  @override
  _PointerLayerState createState() => _PointerLayerState();
}

class _PointerLayerState extends State<PointerLayer> {
  bool isDragging = false;
  bool isDraggingCanvas = false;
  bool isDraggingConnector = false;
  bool isShowingContextMenu = false;
  Offset contentMenuOffset;
  Offset startConnectorOffset, endConnectorOffset;
  Offset startDraggingNodeOffset;

  Document get document => Provider.of<Document>(context, listen: false);
  Selection get selection => Provider.of<Selection>(context, listen: false);
  EditorState get editorState => Provider.of<EditorState>(context, listen: false);

  Offset _translateLocalPosition(Offset pos) =>
      pos / editorState.zoomScale - editorState.canvasOffset;

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
              final pos = _translateLocalPosition(renderBox.globalToLocal(details.offset));
              createNode(details.data, pos);
            },
            builder: (context, candidateData, rejectedData) => Container(),
          ),
          if (isDraggingConnector)
            Transform(
              transform: Matrix4.translationValues(0, 0, 0)..scale(editorState.zoomScale),
              child: _ConnectingNodesView(
                startConnectorOffset,
                endConnectorOffset,
              ),
            ),
          if (isShowingContextMenu)
            Transform(
              transform: Matrix4.translationValues(contentMenuOffset.dx, contentMenuOffset.dy, 0),
              child: ContextMenu(
                NodeActionBuilder(
                  document,
                  selection.selectedNode,
                ).build(),
                handleActionItem,
              ),
            ),
        ],
      ),
      onPointerMove: onPointerMove,
      onPointerDown: onPointerDown,
      onPointerUp: onPointerUp,
      onPointerSignal: onPointerSignal,
    );
  }

  void createNode(NodeTemplate template, Offset pos) {
    Command.createNode(document, selection, template, pos).run();
  }

  void onPointerMove(PointerMoveEvent event) {
    final localPosition = _translateLocalPosition(event.localPosition);
    if (!isDragging) {
      isDragging = true;
      final node = hitTest(localPosition);
      selection.select(node);
      if (node == null) {
        isDraggingCanvas = true;
      } else {
        isDraggingCanvas = false;
        final slot = node.hitTest(localPosition - node.position);
        if (slot != null) {
          isDraggingConnector = true;
          startConnectorOffset = node.slotConnectorPosition(slot);
          endConnectorOffset = localPosition;
        } else {
          // Start dragging node
          startDraggingNodeOffset = node.position;
        }
      }

      FocusHelper.unfocus(context);
    }

    if (isDraggingCanvas) {
      /// Canvas is drawing outside thus should be affected by the zoom scale.
      editorState.moveCanvas(event.delta / editorState.zoomScale);
    } else if (isDraggingConnector) {
      final source = selection.selectedNode;
      final target = hitTest(localPosition);
      if (document.canConnect(parent: source, child: target)) {
        selection.hover(target);
      } else {
        selection.hover(null);
      }
      setState(() {
        endConnectorOffset += event.delta / editorState.zoomScale;
      });
    } else {
      /// Dragging a node
      final node = selection.selectedNode;
      node.position = node.position + event.delta / editorState.zoomScale;
    }
  }

  void onPointerDown(PointerDownEvent event) {
    final localPosition = _translateLocalPosition(event.localPosition);
    final node = hitTest(localPosition);
    if (node != null) {
      selection.select(node);
    }

    if (node != null && event.buttons & kSecondaryMouseButton == kSecondaryMouseButton) {
      final size = menuSize();
      var menuOffset = event.localPosition;

      final visibleArea = EditorDimensions.visibleCanvasArea(context);

      final renderBox = context.findRenderObject() as RenderBox;
      var menuPosition = renderBox.localToGlobal(menuOffset);

      /// Handle context menu position but don't try too much effort.
      /// A possible better way to do this is rendering the context menu on top
      /// level of the views (outsize editor layers) so that even when it's
      /// outside the editor canvas area we can still show it.
      if (menuOffset.dx + size.width > context.size.width) {
        menuOffset -= Offset(size.width, 0);
        menuPosition = renderBox.localToGlobal(menuOffset);
      }
      if (menuPosition.dx + size.width > visibleArea.right) {
        menuOffset -= Offset(size.width, 0);
        menuPosition = renderBox.localToGlobal(menuOffset);
      }
      if (menuOffset.dy + size.height > context.size.height) {
        menuOffset -= Offset(0, size.height);
        menuPosition = renderBox.localToGlobal(menuOffset);
      }
      if (menuPosition.dy + size.height > visibleArea.bottom) {
        menuOffset -= Offset(0, size.height);
        menuPosition = renderBox.localToGlobal(menuOffset);
      }
      if (size == Size.zero || menuOffset.dx < 0 || menuOffset.dy < 0) {
        if (isShowingContextMenu) {
          setState(() {
            isShowingContextMenu = false;
          });
        }
        return;
      }

      setState(() {
        isShowingContextMenu = true;
        contentMenuOffset = menuOffset;
      });
    } else {
      if (isShowingContextMenu) {
        if (!menuSize().contains(event.localPosition - contentMenuOffset)) {
          // Not clicking menu items.
          setState(() {
            isShowingContextMenu = false;
          });
        }
      } else {
        if (node == null) {
          selection.select(null);
        }
      }
    }
  }

  void onPointerUp(PointerUpEvent event) {
    final localPosition = _translateLocalPosition(event.localPosition);
    isDragging = false;
    isDraggingCanvas = false;

    final source = selection.selectedNode;
    if (source == null) {
      return;
    }

    if (isDraggingConnector) {
      final slot = source.hitTest(startConnectorOffset - source.position);
      final target = hitTest(localPosition);
      if (document.canConnect(parent: source, child: target)) {
        Command.connect(document, source, target, slot).run();
      }
      selection.hover(null);
      setState(() {
        startConnectorOffset = endConnectorOffset = null;
        isDraggingConnector = false;
      });
    } else {
      if (!isShowingContextMenu) {
        Command.movePosition(
          document,
          source,
          source.position + event.delta / editorState.zoomScale,
          startDraggingNodeOffset, // Undo would revert all small positions changes during the drag
        ).run();
      }
    }
  }

  void onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      editorState.moveCanvas(-event.scrollDelta / editorState.zoomScale);
    }
  }

  Node hitTest(Offset point) {
    for (final node in document.nodes.reversed) {
      if (node.size.contains(point - node.position)) {
        return node;
      }
    }
    return null;
  }

  void handleActionItem(NodeActionItem item) {
    setState(() {
      isShowingContextMenu = false;
    });
    final executor = NodeActionExecutor(document, selection);
    executor.execute(item.value);
  }

  Size menuSize() {
    final actions = NodeActionBuilder(
      document,
      selection.selectedNode,
    ).build();

    if (actions.isEmpty) {
      return Size.zero;
    }

    /// Context menu should not zoom with canvas
    return ContextMenu.sizeFor(actions) / editorState.zoomScale;
  }
}

/// Draw a link from parent node to child node.
class _ConnectingNodesView extends StatelessWidget {
  final Offset start, end;
  _ConnectingNodesView(this.start, this.end);

  @override
  Widget build(BuildContext context) {
    final editorState = Provider.of<EditorState>(context);

    /// This view only draws the dragging connector to link nodes.
    /// It should not eat any mouse event itself.
    return IgnorePointer(
      child: CustomPaint(
        painter: _ConnectingNodesPainter(
          start + editorState.canvasOffset,
          end + editorState.canvasOffset,
        ),
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

    final edge = EdgePath(start + Offset(6, 0), end);
    canvas.drawPath(edge.edgePath, paint);
    canvas.drawPath(edge.arrowPath, paint);
  }

  @override
  bool shouldRepaint(_ConnectingNodesPainter old) {
    return old.start != start || old.end != end;
  }
}
