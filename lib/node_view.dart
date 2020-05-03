import 'package:flutter/material.dart';

import 'models/selection.dart';
import 'models/node.dart';

class NodeView extends StatefulWidget {
  final Node node;
  final Selection selection;

  NodeView(this.node, this.selection);

  Size get size => Size(120, 200);

  @override
  _NodeViewState createState() => _NodeViewState();
}

class _NodeViewState extends State<NodeView> {
  bool get isSelected => widget.selection.isNodeSelected(widget.node);
  Size get size => Size(120, 200); // TODO: should calculate this

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.node.position.dx,
      top: widget.node.position.dy,
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Container(
            color: Colors.grey[300],
          ),
          Container(
            height: 30,
            width: double.infinity,
            color: Colors.purple[300],
            child: Center(
              child: Text(
                "I'm a node",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(),
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
            ),
          ),
          if (isSelected)
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.blue[700]),
                ),
              ),
            )
        ],
      ),
    );
  }
}
