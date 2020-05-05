import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document.dart';
import 'models/selection.dart';

import 'object_panel.dart';
import 'editor_views/canvas_layer.dart';
import 'editor_views/edges_layer.dart';
import 'editor_views/graphs_layer.dart';
import 'editor_views/drag_target_layer.dart';

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
                  GraphsLayer(
                    zoomScale,
                    (offset) => _moveCanvas(offset),
                  ),
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

  Widget _zoomControls() {
    Function zoomOutPressed() {
      if ((zoomScale * 100).round() <= 20) {
        return null;
      }
      return () => {_scaleCanvas(zoomScale - 0.2)};
    }

    Function zoomInPressed() {
      if ((zoomScale * 100).round() >= 200) {
        return null;
      }
      return () => {_scaleCanvas(zoomScale + 0.2)};
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

  void _moveCanvas(Offset offset) {
    setState(() {
      canvasOffset += offset;
    });
  }

  void _scaleCanvas(double scale) {
    final zoomScale = min(max(0.2, scale), 2.0);
    setState(() {
      this.zoomScale = zoomScale;
    });
  }
}
