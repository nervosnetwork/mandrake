import 'package:flutter/material.dart';

import 'models/node.dart';

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
      padding: EdgeInsets.only(top: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < 8; i++)
            Container(
              padding: const EdgeInsets.all(4),
              child: Draggable<NodeMeta>(
                child: _NodeTemplate(),
                feedback: _DragFeedbackObject(),
                data: NodeMeta(),
              ),
            ),
        ],
      ),
    );
  }
}

class _NodeTemplate extends StatelessWidget {
  _NodeTemplate({this.borderColor = Colors.transparent});
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: borderColor),
      ),
      padding: EdgeInsets.all(2),
      width: 140,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.border_all,
            size: 24,
          ),
          SizedBox(width: 8),
          const Text('Operand'),
        ],
      ),
    );
  }
}

class _DragFeedbackObject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: _NodeTemplate(borderColor: Colors.blue[600]),
    );
  }
}
