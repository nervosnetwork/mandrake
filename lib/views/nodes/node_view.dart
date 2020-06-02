import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import '../../models/selection.dart';

class NodeView extends StatelessWidget {
  static const double borderRadius = 5;

  static const Color normalBorderColor = Color(0xffbdbdbd);
  static const Color selectedBorderColor = Color(0xff007aff);
  static const Color hoveredBorderColor = Color(0xffef5350);
  static const Color subtitleColor = Color(0xff757575);

  bool isSelected(BuildContext context) {
    final node = Provider.of<Node>(context, listen: false);
    final selection = Provider.of<Selection>(context, listen: false);
    return selection.isNodeSelected(node);
  }

  BoxDecoration titleDecoration(Color color) {
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
          decoration: titleDecoration(Theme.of(context).accentColor),
          child: Center(
            child: Text(
              node.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
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
    final borderWidth = isSelected || isHovered ? 2.0 : 1.0;
    final borderColor =
        isSelected ? selectedBorderColor : (isHovered ? hoveredBorderColor : normalBorderColor);

    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      width: node.size.width,
      height: node.size.height,
      child: Stack(
        children: [
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(),
          ),
          buildView(context),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: borderWidth,
                  color: borderColor,
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
