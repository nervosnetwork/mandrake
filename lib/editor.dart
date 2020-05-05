import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document.dart';
import 'models/selection.dart';
import 'models/node.dart';
import 'object_panel.dart';
import 'node_views/node_view.dart';

const double _objectPanelWidth = 240;
const double _canvasMargin = 20;

class Editor extends StatelessWidget {
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
                  _CanvasLayer(),
                  _EdgesLayer(),
                  _graphsLayer(context),
                  _DragTargetLayer(),
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
      height: 40,
      child: Row(
        children: [
          Text('${(zoomScale * 100).round().toInt()}%'),
          IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: zoomOutPressed(),
          ),
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: zoomInPressed(),
          ),
        ],
      ),
    );
  }
}

class _CanvasLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: CustomPaint(
        painter: _CanvasGridPainter(),
        child: Container(),
      ),
    );
  }
}

class _CanvasGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..color = Color(0xFFE3F2FD);

    for (var i = 20; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (var i = 20; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CanvasGridPainter oldPainter) => false;
}

class _EdgesLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Document>(builder: (context, document, child) {
      return CustomPaint(
        painter: _EdgesPainter(document.nodes),
        child: Container(),
      );
    });
  }
}

class _EdgesPainter extends CustomPainter {
  List<Node> nodes;
  _EdgesPainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = Colors.green;

    // Draw a test edge between every two nodes.
    for (var i = 0; i < nodes.length - 1; i++) {
      final path = Path();
      final start = nodes[i].position + Offset(120, 15);
      final end = nodes[i + 1].position + Offset(0, 15);
      final distance = (end - start).distance;
      final offset = distance * 0.25;

      path.moveTo(start.dx, start.dy);
      path.cubicTo(
        start.dx + offset, // (end.dx > start.dx ? offset : -offset),
        start.dy, // + (end.dy > start.dy ? offset : -offset),
        end.dx - offset, //(end.dx > start.dx ? offset : -offset),
        end.dy, // - (end.dy > start.dy ? offset : -offset),
        end.dx,
        end.dy,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_EdgesPainter oldPainter) => false;
}

class _DragTargetLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Document, Selection>(
      builder: (_, document, selection, child) {
        return DragTarget<String>(
          onWillAccept: (data) {
            print('data = $data onWillAccept');
            return data != null;
          },
          onAcceptWithDetails: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final pos = renderBox.globalToLocal(details.offset);

            final node = Node(pos);
            document.addNode(node);
            selection.select(node);
          },
          builder: (context, candidateData, rejectedData) => Container(),
        );
      },
    );
  }
}
