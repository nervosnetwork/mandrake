import 'package:flutter/material.dart';

import '../models/selection.dart';
import '../models/node.dart';

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
  bool get isHovered => widget.selection.isNodeHovered(widget.node);
  Size get size => Size(120, 200); // TODO: should calculate this

  final double _borderRadius = 5;

  final Color _bgColor = Colors.blue[50];
  final Color _borderColor = Colors.blue[300];
  final Color _selectedBorderColor = Color(0xff007aff);
  final Color _hoveredBorderColor = Colors.red[400];
  final Color _titleColor = Colors.indigo[700];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.node.position.dx,
      top: widget.node.position.dy,
      width: size.width,
      height: size.height,
      child: buildView(),
    );
  }

  Widget buildView() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _bgColor,
            border: Border.all(width: 1, color: _borderColor),
            borderRadius: BorderRadius.circular(_borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        Container(
          height: 30,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _titleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_borderRadius),
              topRight: Radius.circular(_borderRadius),
            ),
          ),
          child: Center(
            child: Text(
              'A Node',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (isSelected || isHovered)
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: isSelected ? _selectedBorderColor : _hoveredBorderColor,
                ),
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
            ),
          )
      ],
    );
  }
}
