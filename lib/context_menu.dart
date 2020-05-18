import 'package:flutter/material.dart';

import 'models/node_action.dart';

typedef NodeActionItemSelected = void Function(NodeActionItem item);

class ContextMenu extends StatefulWidget {
  ContextMenu(this.items, this.onSelcted);

  final List<NodeActionItem> items;
  final NodeActionItemSelected onSelcted;

  @override
  _ContextMenuState createState() => _ContextMenuState();

  /// Sometimes we need to know the dimension of the menu.
  static Size sizeFor(List<NodeActionItem> items) {
    return Size(240, _padding * 2 + items.length * _itemHeight + _borderWidth * 2);
  }

  static const double _itemHeight = 26;
  static const double _padding = 6;
  static const double _borderWidth = 1;
}

class _ContextMenuState extends State<ContextMenu> {
  @override
  Widget build(BuildContext context) {
    final size = ContextMenu.sizeFor(widget.items);

    return Material(
      borderRadius: BorderRadius.circular(ContextMenu._padding / 2),
      color: Theme.of(context).dialogBackgroundColor,
      elevation: 2,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          border: Border.all(
            width: ContextMenu._borderWidth,
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.circular(ContextMenu._padding / 2),
        ),
        padding: EdgeInsets.symmetric(vertical: ContextMenu._padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.items.map((item) => itemButton(item)).toList(),
        ),
      ),
    );
  }

  Widget itemButton(NodeActionItem item) {
    return SizedBox(
      height: ContextMenu._itemHeight,
      child: FlatButton(
        onPressed: () => widget.onSelcted(item),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            item.label,
            textAlign: TextAlign.left,
          ),
        ),
        hoverColor: Colors.blue,
      ),
    );
  }
}
