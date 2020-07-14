import 'package:flutter/material.dart';

import 'views/editor/editor_dimensions.dart';

typedef MenuItemSelected = void Function(String item);

final subMenuWidth = 200.0;

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  var currentSubMenuIndex = -1;
  bool get subMenuIsShowing => currentSubMenuIndex != -1;

  @override
  Widget build(BuildContext context) {
    final subMenu = currentSubMenu();

    return Stack(
      fit: StackFit.expand,
      children: [
        Listener(
          behavior: subMenuIsShowing ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
          child: Container(),
          onPointerDown: (event) {
            selectSubMenu(-1);
          },
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            mainMenuItem(_MenuItem('File', () => selectSubMenu(0))),
            mainMenuItem(_MenuItem('View', () => selectSubMenu(1))),
          ],
        ),
        if (subMenu != null)
          Positioned(
            top: EditorDimensions.toolbarHeight,
            left: 10 + currentSubMenuIndex * 80.0,
            height: subMenu.size.height,
            width: subMenu.size.width,
            child: subMenu,
          ),
      ],
    );
  }

  void selectSubMenu(int index) {
    setState(() {
      currentSubMenuIndex = index;
    });
  }

  _Menu currentSubMenu() {
    final menus = [
      _Menu(
        [
          _MenuItem('New File', () => {}),
          _MenuItem('Open File', () => {}),
          _MenuItem('Save File', () => {}),
          _MenuItem('Export AST', () => {}),
        ],
      ),
      _Menu(
        [
          _MenuItem('Actual Size', () => {}),
          _MenuItem('Zoom In', () => {}),
          _MenuItem('Zoom Out', () => {}),
        ],
      ),
    ];
    return subMenuIsShowing ? menus[currentSubMenuIndex] : null;
  }

  Widget mainMenuItem(_MenuItem item) {
    return FlatButton(
      child: Text(item.title),
      onPressed: item.onPressed,
      splashColor: Colors.transparent,
    );
  }
}

class _MenuItem {
  _MenuItem(this.title, this.onPressed);

  final String title;
  final Function onPressed;
}

class _Menu extends StatelessWidget {
  _Menu(this.items);

  final List<_MenuItem> items;

  Size get size {
    return Size(subMenuWidth, padding * 2 + items.length * itemHeight + borderWidth * 2);
  }

  static const double itemHeight = 26;
  static const double padding = 6;
  static const double borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(_Menu.padding / 2),
      color: Theme.of(context).dialogBackgroundColor,
      elevation: 8,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          border: Border.all(
            width: _Menu.borderWidth,
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.circular(_Menu.padding / 2),
        ),
        padding: EdgeInsets.symmetric(vertical: _Menu.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items.map((item) => itemButton(item)).toList(),
        ),
      ),
    );
  }

  Widget itemButton(_MenuItem item) {
    return SizedBox(
      height: _Menu.itemHeight,
      child: FlatButton(
        onPressed: () => item.onPressed,
        child: SizedBox(
          width: double.infinity,
          child: Text(
            item.title,
            textAlign: TextAlign.left,
          ),
        ),
        hoverColor: Colors.blue,
      ),
    );
  }
}
