import 'package:flutter/material.dart';

import 'models/selection.dart';
import 'models/node.dart';

class NodeView extends StatefulWidget {
  final Node node;
  final Selection selection;

  NodeView(this.node, this.selection);

  @override
  State<StatefulWidget> createState() => _NodeViewState(node, selection);
}

class _NodeViewState extends State<NodeView> {
  final Node node;
  final Selection selection;

  bool get isSelected => selection.isNodeSelected(node);

  _NodeViewState(this.node, this.selection);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      width: 48,
      height: 48,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selection.select(node);
              });
            },
            child: Icon(
              Icons.tag_faces,
              size: 48,
              color: Colors.pink,
            ),
          ),
          if (isSelected)
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.blue[800]),
                ),
              ),
            )
        ],
      ),
    );
  }
}
