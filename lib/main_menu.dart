import 'package:flutter/material.dart';

import 'views/editor/editor_dimensions.dart';

typedef MenuItemSelected = void Function(String item);

final subMenuWidth = 200.0;

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      'Menu Item 1',
      'Menu Item 2',
    ];
    final size = Menu.sizeFor(items);

    return Stack(
      fit: StackFit.expand,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _menuItem('File', () {}),
            _menuItem('Edit', () {}),
          ],
        ),
        Positioned(
          top: EditorDimensions.toolbarHeight,
          left: 10,
          height: size.height,
          width: size.width,
          child: Menu(items, (String title) {
            print(title);
          }),
        ),
      ],
    );
  }

  Widget _menuItem(String title, Function onPressed) {
    return FlatButton(
      child: Text(title),
      onPressed: onPressed,
      splashColor: Colors.transparent,
    );
  }
}

class Menu extends StatefulWidget {
  Menu(this.items, this.onSelcted);

  final List<String> items;
  final MenuItemSelected onSelcted;

  @override
  _MenuState createState() => _MenuState();

  /// Sometimes we need to know the dimension of the menu.
  static Size sizeFor(List<String> items) {
    return Size(subMenuWidth, _padding * 2 + items.length * _itemHeight + _borderWidth * 2);
  }

  static const double _itemHeight = 26;
  static const double _padding = 6;
  static const double _borderWidth = 1;
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final size = Menu.sizeFor(widget.items);

    return Material(
      borderRadius: BorderRadius.circular(Menu._padding / 2),
      color: Theme.of(context).dialogBackgroundColor,
      elevation: 8,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          border: Border.all(
            width: Menu._borderWidth,
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.circular(Menu._padding / 2),
        ),
        padding: EdgeInsets.symmetric(vertical: Menu._padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.items.map((item) => itemButton(item)).toList(),
        ),
      ),
    );
  }

  Widget itemButton(String item) {
    return SizedBox(
      height: Menu._itemHeight,
      child: FlatButton(
        onPressed: () => widget.onSelcted(item),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            item,
            textAlign: TextAlign.left,
          ),
        ),
        hoverColor: Colors.blue,
      ),
    );
  }
}
