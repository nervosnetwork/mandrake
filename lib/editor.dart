import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document.dart';
import 'models/selection.dart';

import 'object_panel.dart';
import 'editor_views/canvas_layer.dart';
import 'editor_views/edges_layer.dart';
import 'editor_views/drag_target_layer.dart';
import 'node_views/node_view.dart';

class Editor extends StatelessWidget {
  final double _objectPanelWidth = 240;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, constraints) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: _objectPanelWidth,
            right: 0,
            bottom: 0,
            child: DesignEditor(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: constraints.maxWidth - _objectPanelWidth,
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
  _DesignEditorState createState() => _DesignEditorState();
}

class _DesignEditorState extends State<DesignEditor> {
  Offset canvasOffset = Offset.zero;
  double zoomScale = 1;

  final double _canvasMargin = 20;
  bool _isDragging = false;
  bool _isDraggingCanvas = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Document>(create: (_) => Document()),
        ChangeNotifierProvider<Selection>(create: (_) => Selection()),
      ],
      child: Stack(
        children: [
          Container(
            color: Colors.grey[400],
          ),
          Positioned(
            left: _canvasMargin,
            top: _canvasMargin,
            right: _canvasMargin,
            bottom: _canvasMargin,
            child: Transform(
              transform: Matrix4.translationValues(
                canvasOffset.dx,
                canvasOffset.dy,
                0,
              )..scale(zoomScale, zoomScale, 1),
              child: Stack(
                children: [
                  CanvasLayer(),
                  EdgesLayer(),
                  _graphsLayer(context),
                  DragTargetLayer(),
                ],
              ),
            ),
          ),
          _zoomControls(),
        ],
      ),
    );
  }

  Widget _graphsLayer(BuildContext context) {
    return Consumer2<Document, Selection>(builder: (context, document, selection, child) {
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
            _isDragging = true;
            final node = hitTest(event.localPosition);
            if (node != null) {
              selection.select(node);
              setState(() {
                _isDraggingCanvas = false;
              });
            } else {
              selection.select(null);
              setState(() {
                _isDraggingCanvas = true;
              });
            }
          }

          if (_isDraggingCanvas) {
            setState(() {
              canvasOffset += event.delta;
            });
          } else {
            document.moveNodePosition(
              selection.selectedNode(document.nodes),
              event.delta / zoomScale,
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
    });
  }

  Widget _zoomControls() {
    Function zoomOutPressed() {
      if ((zoomScale * 100).round() <= 20) {
        return null;
      }
      return () => {
            setState(() {
              zoomScale = max(0.2, zoomScale - 0.2);
            })
          };
    }

    Function zoomInPressed() {
      if ((zoomScale * 100).round() >= 200) {
        return null;
      }
      return () => {
            setState(() {
              zoomScale = min(2, zoomScale + 0.2);
            })
          };
    }

    return Positioned(
      bottom: _canvasMargin,
      right: _canvasMargin,
      width: 36,
      child: Column(
        children: [
          Text(
            '${(zoomScale * 100).round().toInt()}%',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.zoom_in),
                  onPressed: zoomInPressed(),
                ),
                Divider(
                  indent: 4,
                  endIndent: 4,
                  height: 1,
                ),
                IconButton(
                  icon: Icon(Icons.zoom_out),
                  onPressed: zoomOutPressed(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
