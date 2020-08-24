import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truncate/truncate.dart';

import '../io/io.dart';
import '../models/editor_state.dart';
import '../models/recent_files.dart';
import '../models/undo_manager.dart';
import '../views/editor/editor_dimensions.dart';

typedef MenuItemSelected = void Function(String item);

final subMenuWidth = 400.0;

class MainMenu extends StatefulWidget {
  MainMenu({
    this.onNewDocument,
    this.onNewDocumentFromTemplate,
    this.onOpenDocument,
    this.onOpenDocumentHandle,
    this.onSaveDocument,
    this.onSaveDocumentAs,
    this.onExportAst,
    this.onLocateRootNode,
  });
  final Function onNewDocument;
  final Function onNewDocumentFromTemplate;
  final Function onOpenDocument;
  final Function onOpenDocumentHandle;
  final Function onSaveDocument;
  final Function onSaveDocumentAs;
  final Function onExportAst;
  final Function onLocateRootNode;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  var currentSubMenuIndex = -1;
  bool get subMenuIsShowing => currentSubMenuIndex != -1;

  @override
  Widget build(BuildContext context) {
    final subMenu = currentSubMenu(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Listener(
          behavior: subMenuIsShowing ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
          child: Container(),
          onPointerDown: (event) => dismissSubMenu(),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(width: 8),
            mainMenuItem(_MenuItem('File', () => selectSubMenu(0))),
            mainMenuItem(_MenuItem('Edit', () => selectSubMenu(1))),
            mainMenuItem(_MenuItem('View', () => selectSubMenu(2))),
          ],
        ),
        if (subMenu != null)
          Positioned(
            top: EditorDimensions.toolbarHeight,
            left: 8 + currentSubMenuIndex * 80.0,
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

  void dismissSubMenu() => selectSubMenu(-1);

  _Menu currentSubMenu(BuildContext context) {
    final editorState = Provider.of<EditorState>(context);
    final recentFiles = Provider.of<RecentFiles>(context);
    final recentFilesItems = recentFiles.files().map((file) {
      return _MenuItem(
        truncate(file.name, 50, position: TruncatePosition.middle),
        () {
          widget.onOpenDocumentHandle(file);
        },
      );
    }).toList();

    final menus = [
      _Menu(
        [
          _MenuItem('New File', widget.onNewDocument),
          _MenuItem('New File from Template...', widget.onNewDocumentFromTemplate),
          _MenuItem('Open...', widget.onOpenDocument),
          _SeparatorMenuItem(),
          _MenuItem('Save', widget.onSaveDocument),
          if (isFileSystemAvailable()) ...[
            _MenuItem('Save As...', widget.onSaveDocumentAs),
          ],
          if (!isFileSystemAvailable()) ...[
            _MenuItem('Enable Native File System API...', () {
              showNativeFileSystemGuide(context);
            }),
          ],
          if (isFileSystemAvailable()) ...[
            _SeparatorMenuItem(),
            _MenuItem('Recent Files', null),
            ...recentFilesItems,
          ],
          _SeparatorMenuItem(),
          _MenuItem('Export AST...', widget.onExportAst),
        ],
        dismissSubMenu,
      ),
      _Menu(
        [
          _MenuItem('Undo', UndoManager.shared().canUndo ? () => undo() : null),
          _MenuItem('Redo', UndoManager.shared().canRedo ? () => redo() : null),
        ],
        dismissSubMenu,
      ),
      _Menu(
        [
          _MenuItem('Actual Size', () => {editorState.zoomTo(1)}),
          _MenuItem('Zoom In', editorState.zoomInAction),
          _MenuItem('Zoom Out', editorState.zoomOutAction),
          _SeparatorMenuItem(),
          _MenuItem('Move to Canvas Origin', editorState.resetCanvasOffset),
          _MenuItem('Locate Root Node', widget.onLocateRootNode),
        ],
        dismissSubMenu,
      ),
    ];
    return subMenuIsShowing ? menus[currentSubMenuIndex] : null;
  }

  Widget mainMenuItem(_MenuItem item) {
    return MouseRegion(
      onHover: (event) {
        if (subMenuIsShowing) {
          item.onPressed();
        }
      },
      child: FlatButton(
        child: Text(item.title),
        onPressed: item.onPressed,
        splashColor: Colors.transparent,
      ),
    );
  }
}

class _MenuItem {
  _MenuItem(this.title, this.onPressed);

  final String title;
  final Function onPressed;
}

class _SeparatorMenuItem extends _MenuItem {
  _SeparatorMenuItem() : super('', null);
}

class _Menu extends StatelessWidget {
  _Menu(this.items, this.dismiss);

  final List<_MenuItem> items;
  final Function dismiss;

  Size get size {
    final separatorCount = items.whereType<_SeparatorMenuItem>().length;
    return Size(
      subMenuWidth,
      padding * 2 +
          (items.length - separatorCount) * itemHeight +
          separatorCount * itemHeight / 2 +
          borderWidth * 2,
    );
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
    if (item is _SeparatorMenuItem) {
      return Divider(
        height: _Menu.itemHeight / 2,
        indent: 8,
        endIndent: 8,
      );
    } else {
      final onPressed = item.onPressed != null
          ? () {
              dismiss();
              item.onPressed();
            }
          : null;
      return SizedBox(
        height: _Menu.itemHeight,
        child: FlatButton(
          onPressed: onPressed,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              item.title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              maxLines: 1,
            ),
          ),
          hoverColor: Colors.blue,
          splashColor: Colors.transparent,
        ),
      );
    }
  }
}
