import 'package:flutter/material.dart';

import 'models/editor_bag.dart';

class ObjectPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ObjectPanelState();
  }
}

class _ObjectPanelState extends State<ObjectPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 8; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Draggable(
                  child: _TestItem(),
                  feedback: _FeedbackTestItem(),
                  onDragEnd: onDragEnd,
                  data: '<dragging item>',
                ),
                Draggable(
                  child: _TestItem(),
                  feedback: _FeedbackTestItem(),
                  onDragEnd: onDragEnd,
                  data: '<dragging item>',
                ),
              ],
            )
        ],
      ),
    );
  }

  void onDragEnd(DraggableDetails drag) {
    if (drag.wasAccepted) {
      editorBag.lastDropOffset = drag.offset;
    }
  }
}

class _TestItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.tag_faces,
      size: 48,
    );
  }
}

class _FeedbackTestItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.tag_faces,
      size: 48,
      color: Colors.grey,
    );
  }
}
