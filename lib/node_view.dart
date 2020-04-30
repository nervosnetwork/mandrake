import 'package:flutter/material.dart';

import 'models/selection.dart';
import 'models/node.dart';

class NodeView extends StatefulWidget {
  final Node node;
  final Selection selection;

  NodeView(this.node, this.selection);

  Size get size => Size(48, 48);

  @override
  State<StatefulWidget> createState() => _NodeViewState(node, selection);
}

class _NodeViewState extends State<NodeView> {
  final Node node;
  final Selection selection;

  _NodeViewState(this.node, this.selection);

  bool get isSelected => selection.isNodeSelected(node);
  Size get size => Size(48, 48); // TODO: should calcuate this

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
            },
            child: Icon(
              Icons.tag_faces,
              size: size.width,
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
