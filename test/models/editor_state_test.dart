import 'package:flutter_test/flutter_test.dart';
import 'package:mandrake/models/editor_state.dart';

void main() {
  test('move canvas', () {
    final state = EditorState();
    expect(state.canvasOffset, offsetMoreOrLessEquals(Offset.zero));
    state.moveCanvas(Offset(100, 100));
    expect(state.canvasOffset, offsetMoreOrLessEquals(Offset(100, 100)));
  });

  group('zooming', () {
    test('zoom in', () {
      final state = EditorState();
      expect(state.zoomScale, moreOrLessEquals(1.0));
      state.zoomIn(); // 1.2
      state.zoomIn(); // 1.4
      state.zoomIn(); // 1.6
      state.zoomIn(); // 1.8
      expect(state.zoomScale, moreOrLessEquals(1.8));
      expect(state.zoomInAction != null, true);
      state.zoomIn(); // 2.0
      expect(state.zoomScale, moreOrLessEquals(2.0));
      expect(state.zoomInAction == null, true);
      state.zoomIn(); // 2.0 as max
      expect(state.zoomScale, moreOrLessEquals(2.0));
    });

    test('zoom out', () {
      final state = EditorState();
      expect(state.zoomScale, moreOrLessEquals(1.0));
      state.zoomOut(); // 0.8
      state.zoomOut(); // 0.6
      state.zoomOut(); // 0.4
      expect(state.zoomScale, moreOrLessEquals(0.4));
      expect(state.zoomOutAction != null, true);
      state.zoomOut(); // 0.2
      expect(state.zoomScale, moreOrLessEquals(0.2));
      expect(state.zoomOutAction == null, true);
      state.zoomOut(); // 0.2 as min
      expect(state.zoomScale, moreOrLessEquals(0.2));
    });

    test('zoom to', () {
      final state = EditorState();
      expect(state.zoomScale, moreOrLessEquals(1.0));
      state.zoomTo(2.0);
      expect(state.zoomScale, moreOrLessEquals(2.0));
      expect(state.zoomInAction == null, true);
      state.zoomTo(2.1);
      expect(state.zoomScale, moreOrLessEquals(2.0));
      state.zoomTo(0.2);
      expect(state.zoomScale, moreOrLessEquals(0.2));
      expect(state.zoomOutAction == null, true);
      state.zoomTo(0.1);
      expect(state.zoomScale, moreOrLessEquals(0.2));
      state.zoomTo(1.1);
      expect(state.zoomScale, moreOrLessEquals(1.1));
      expect(state.zoomInAction != null, true);
      expect(state.zoomOutAction != null, true);
    });
  });
}
