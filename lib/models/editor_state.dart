import 'dart:math';
import 'dart:ui' show Offset;
import 'package:flutter/foundation.dart';

class EditorState extends ChangeNotifier {
  Offset _canvasOffset = Offset.zero;
  double _zoomScale = 1;

  final double _minZoomScale = 0.2;
  final double _maxZoomScale = 2;

  Offset get canvasOffset => _canvasOffset;
  double get zoomScale => _zoomScale;

  Function get zoomInAction {
    if ((zoomScale * 100).round() >= (_maxZoomScale * 100).round()) {
      return null;
    }
    return zoomIn;
  }

  Function get zoomOutAction {
    if ((zoomScale * 100).round() <= (_minZoomScale * 100).round()) {
      return null;
    }
    return zoomOut;
  }

  void resetCanvasOffset() {
    _canvasOffset = Offset.zero;
    notifyListeners();
  }

  void moveCanvas(Offset offset) {
    _canvasOffset += offset;
    notifyListeners();
  }

  void zoomTo(double scale) {
    _zoomScale = min(max(_minZoomScale, scale), _maxZoomScale);
    notifyListeners();
  }

  void zoomIn() => zoomTo(zoomScale + 0.2);

  void zoomOut() => zoomTo(zoomScale - 0.2);
}
