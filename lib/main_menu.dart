import 'package:flutter/material.dart';

import 'views/editor/editor_dimensions.dart';

typedef MenuItemSelected = void Function(String item);

final subMenuWidth = 200.0;

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  var _currentSubMenuIndex = -1;
  bool get subMenuIsShowing => _currentSubMenuIndex != -1;

  @override
  Widget build(BuildContext context) {
    final subMenu = _subMenu();

    return Stack(
      fit: StackFit.expand,
      children: [
        Listener(
          behavior: subMenuIsShowing ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
          child: Container(),
          onPointerDown: (event) {
            _selectSubMenu(-1);
          },
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _menuItem('File', () => _selectSubMenu(0)),
            _menuItem('View', () => _selectSubMenu(1)),
          ],
        ),
        if (subMenu != null)
          Positioned(
            top: EditorDimensions.toolbarHeight,
            left: 10 + _currentSubMenuIndex * 80.0,
            height: subMenu.size.height,
            width: subMenu.size.width,
            child: subMenu,
          ),
      ],
    );
  }

  void _selectSubMenu(int index) {
    setState(() {
      _currentSubMenuIndex = index;
    });
  }

  Menu _subMenu() {
    final menus = [
      Menu(
        [
          'New File',
          'Open File',
          'Save File',
          'Export AST',
        ],
        (item) {},
      ),
      Menu(
        [
          'Actual Size',
          'Zoom In',
          'Zoom Out',
        ],
        (item) {},
      ),
    ];
    return subMenuIsShowing ? menus[_currentSubMenuIndex] : null;
  }

  Widget _menuItem(String title, Function onPressed) {
    return FlatButton(
      child: Text(title),
      onPressed: onPressed,
      splashColor: Colors.transparent,
    );
  }
}

class Menu extends StatelessWidget {
  Menu(this.items, this.onSelcted);

  final List<String> items;
  final MenuItemSelected onSelcted;

  Size get size => Menu.sizeFor(items);

  /// Sometimes we need to know the dimension of the menu.
  static Size sizeFor(List<String> items) {
    return Size(subMenuWidth, _padding * 2 + items.length * _itemHeight + _borderWidth * 2);
  }

  static const double _itemHeight = 26;
  static const double _padding = 6;
  static const double _borderWidth = 1;

  @override
  Widget build(BuildContext context) {
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
          children: items.map((item) => itemButton(item)).toList(),
        ),
      ),
    );
  }

  Widget itemButton(String item) {
    return SizedBox(
      height: Menu._itemHeight,
      child: FlatButton(
        onPressed: () => onSelcted(item),
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
