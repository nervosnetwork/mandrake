import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import '../../models/selection.dart';

class NodeView extends StatelessWidget {
  static const double borderRadius = 5;

  static const Color bgColor = Color(0xffe3f2fd);
  static const Color borderColor = Color(0xff64b5f6);
  static const Color selectedBorderColor = Color(0xff007aff);
  static const Color hoveredBorderColor = Color(0xffef5350);
  static const Color titleColor = Color(0xff303f9f);
  static const Color subtitleColor = Color(0xff757575);

  BoxDecoration titleDecoration([Color color = titleColor]) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
    );
  }

  Widget subtitle(BuildContext context, String title) {
    final node = Provider.of<Node>(context);
    return Container(
      height: node.subtitleHeight,
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      color: subtitleColor,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget slot(BuildContext context, ChildSlot slot) {
    final node = Provider.of<Node>(context);
    return Container(
      height: node.slotRowHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Spacer(),
          Container(
            child: Text(
              slot.name,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
            width: node.size.width - 30,
          ),
          SizedBox(width: 4),
          Icon(
            slot.isConnected ? Icons.adjust : Icons.panorama_fish_eye,
            color: slot.isConnected ? Colors.green : Colors.grey,
            size: 15,
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget addChildButton(BuildContext context, [Function onTap]) {
    final node = Provider.of<Node>(context);
    return Container(
      height: node.actionRowHeight,
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.add_box,
              color: onTap != null ? Colors.black : Theme.of(context).disabledColor,
            ),
          )
        ],
      ),
    );
  }

  /// Override this to customize node shape.
  Widget buildView(BuildContext context) {
    final node = Provider.of<Node>(context);
    final slots = node.slots.map((s) => slot(context, s)).toList();

    void onAddChildButtonClicked() {
      node.addSlot('new child');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: node.titleHeight,
          width: double.infinity,
          decoration: titleDecoration(),
          child: Center(
            child: Text(
              node.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        subtitle(context, 'Children'),
        ...slots,
        if (node.canAddSlot) addChildButton(context, onAddChildButtonClicked),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = Provider.of<Node>(context);
    final selection = Provider.of<Selection>(context, listen: false);
    final isSelected = selection.isNodeSelected(node);
    final isHovered = selection.isNodeHovered(node);

    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      width: node.size.width,
      height: node.size.height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(width: 1, color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          buildView(context),
          if (isSelected || isHovered)
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: isSelected ? selectedBorderColor : hoveredBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            )
        ],
      ),
    );
  }
}
