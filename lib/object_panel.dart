import 'package:flutter/material.dart';

class ObjectPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          right: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 8; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Draggable(
                  child: _NodeTemplate(),
                  feedback: _DragFeedbackObject(),
                  data: '<dragging item>',
                ),
                Draggable(
                  child: _NodeTemplate(),
                  feedback: _DragFeedbackObject(),
                  data: '<dragging item>',
                ),
              ],
            )
        ],
      ),
    );
  }
}

class _NodeTemplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      width: 80,
      height: 40,
    );
  }
}

class _DragFeedbackObject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      width: 80,
      height: 40,
    );
  }
}
