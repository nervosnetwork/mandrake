import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/document.dart';
import '../models/selection.dart';

import '../node_views/node_view.dart';

typedef OnCanvasDragged = Function(Offset offset);

class GraphsLayer extends StatefulWidget {
  final double zoomScale;
  final OnCanvasDragged onCanvasDragged;
  GraphsLayer(this.zoomScale, this.onCanvasDragged);

  @override
  _GraphsLayerState createState() => _GraphsLayerState();
}

class _GraphsLayerState extends State<GraphsLayer> {
  bool _isDragging = false;
  bool _isDraggingCanvas = false;

  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);
    final selection = Provider.of<Selection>(context);

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
        children: nodeViews,
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
        }

        if (_isDraggingCanvas) {
          widget.onCanvasDragged(event.delta);
        } else {
          document.moveNodePosition(
            selection.selectedNode(document.nodes),
            event.delta / widget.zoomScale,
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
      },
    );
  }
}
