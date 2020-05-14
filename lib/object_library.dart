import 'package:flutter/material.dart';

class ObjectLibrary extends StatelessWidget {
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
      child: Wrap(
        children: [
          for (var i = 0; i < 8; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
              ),
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
