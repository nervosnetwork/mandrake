import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menubar/menubar.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

import '../models/document.dart';
import '../models/command.dart';
import '../models/editor_state.dart';
import '../models/recent_files.dart';
import '../models/undo_manager.dart';
import '../views/editor/editor_dimensions.dart';

import 'main_menu.dart';

class Toolbar extends StatelessWidget {
  Toolbar({
    this.onNewDocument,
    this.onNewDocumentFromTemplate,
    this.onOpenDocument,
    this.onOpenGist,
    this.onShareGist,
    this.onOpenDocumentHandle,
    this.onSaveDocument,
    this.onSaveDocumentAs,
    this.onExportAst,
  });
  final Function onNewDocument;
  final Function onNewDocumentFromTemplate;
  final Function onOpenDocument;
  final Function onOpenGist;
  final Function onShareGist;
  final Function onOpenDocumentHandle;
  final Function onSaveDocument;
  final Function onSaveDocumentAs;
  final Function onExportAst;

  @override
  Widget build(BuildContext context) {
    return Consumer4<Document, EditorState, CommandState, RecentFiles>(
      builder: (context, document, editorState, commandState, recentFiles, child) {
        updateAppMenu(document, editorState, recentFiles);

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              width: double.infinity,
              height: EditorDimensions.toolbarHeight,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (!Platform.isMacOS || kIsWeb) ...[
                  SizedBox(width: EditorDimensions.mainMenuWidth),
                  _separator(),
                ],
                _iconButton(
                  icon: Icon(Icons.undo),
                  onPressed: UndoManager.shared().canUndo ? () => undo() : null,
                ),
                _iconButton(
                  icon: Icon(Icons.redo),
                  onPressed: UndoManager.shared().canRedo ? () => redo() : null,
                ),
                _separator(),
                _iconButton(
                  icon: Icon(Icons.zoom_out),
                  onPressed: editorState.zoomOutAction,
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    '${(editorState.zoomScale * 100).round()}%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),
                _iconButton(
                  icon: Icon(Icons.zoom_in),
                  onPressed: editorState.zoomInAction,
                ),
                _separator(),
                _iconButton(
                  icon: Icon(Icons.filter_center_focus),
                  onPressed: () => editorState.resetCanvasOffset(),
                ),
                _iconButton(
                  icon: Icon(Icons.developer_board),
                  onPressed: () => _jumpToRoot(document, editorState),
                ),
                _separator(),
                _iconButton(
                  icon: Icon(Icons.save),
                  onPressed: document.isDirty ? onSaveDocument : null,
                ),
                _iconButton(
                  icon: Icon(Icons.share),
                  onPressed: onShareGist,
                ),
              ],
            ),
            if (!Platform.isMacOS || kIsWeb)
              MainMenu(
                onNewDocument: onNewDocument,
                onNewDocumentFromTemplate: onNewDocumentFromTemplate,
                onOpenDocument: onOpenDocument,
                onOpenGist: onOpenGist,
                onShareGist: onShareGist,
                onOpenDocumentHandle: onOpenDocumentHandle,
                onSaveDocument: onSaveDocument,
                onSaveDocumentAs: onSaveDocumentAs,
                onExportAst: onExportAst,
                onLocateRootNode: () => _jumpToRoot(document, editorState),
              ),
          ],
        );
      },
    );
  }

  // Manipulate native macOS menus.
  // Note: this will show error messages on web console, as it's only for desktop.
  void updateAppMenu(
    Document document,
    EditorState editorState,
    RecentFiles recentFiles,
  ) {
    if (!Platform.isMacOS) {
      return;
    }
    if (kIsWeb) {
      return;
    }

    setApplicationMenu([
      Submenu(label: 'File', children: [
        MenuItem(
          label: 'New File',
          enabled: true,
          shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyN),
          onClicked: onNewDocument,
        ),
        MenuItem(
          label: 'New File from Template...',
          enabled: true,
          shortcut: LogicalKeySet(
              LogicalKeyboardKey.shift, LogicalKeyboardKey.meta, LogicalKeyboardKey.keyN),
          onClicked: onNewDocumentFromTemplate,
        ),
        MenuItem(
          label: 'Open...',
          enabled: true,
          shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyO),
          onClicked: onOpenDocument,
        ),
        MenuItem(
          label: 'Open Gist...',
          enabled: true,
          onClicked: onOpenGist,
        ),
        if (recentFiles.files().isNotEmpty)
          Submenu(
            label: 'Open Recent',
            children: recentFiles.files().map((file) {
              return MenuItem(
                label: file.name,
                enabled: true,
                onClicked: () {
                  onOpenDocumentHandle(file);
                },
              );
            }).toList(),
          ),
        MenuDivider(),
        MenuItem(
          label: 'Save',
          enabled: true,
          shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS),
          onClicked: onSaveDocument,
        ),
        MenuItem(
          label: 'Save As...',
          enabled: true,
          shortcut: LogicalKeySet(
              LogicalKeyboardKey.shift, LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS),
          onClicked: onSaveDocumentAs,
        ),
        MenuDivider(),
        MenuItem(
          label: 'Share with GitHub Gists...',
          enabled: true,
          onClicked: onShareGist,
        ),
        MenuItem(
          label: 'Export AST...',
          enabled: true,
          onClicked: onExportAst,
        ),
      ]),
      Submenu(label: 'Edit', children: [
        MenuItem(
          label: 'Undo',
          enabled: UndoManager.shared().canUndo,
          shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ),
          onClicked: undo,
        ),
        MenuItem(
          label: 'Redo',
          enabled: UndoManager.shared().canRedo,
          shortcut: LogicalKeySet(
              LogicalKeyboardKey.shift, LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ),
          onClicked: redo,
        ),
      ]),
      Submenu(label: 'View', children: [
        MenuItem(
          label: 'Actual Size',
          enabled: true,
          onClicked: () {
            editorState.zoomTo(1);
          },
        ),
        MenuItem(
          label: 'Zoom In',
          enabled: editorState.zoomInAction != null,
          onClicked: editorState.zoomInAction,
        ),
        MenuItem(
          label: 'Zoom Out',
          enabled: editorState.zoomOutAction != null,
          onClicked: editorState.zoomOutAction,
        ),
        MenuDivider(),
        MenuItem(
          label: 'Move to Canvas Origin',
          enabled: true,
          onClicked: editorState.resetCanvasOffset,
        ),
        MenuItem(
          label: 'Locate Root Node',
          enabled: true,
          onClicked: () {
            _jumpToRoot(document, editorState);
          },
        ),
      ]),
    ]);
  }

  void _jumpToRoot(Document document, EditorState editorState) {
    final root = document.root;
    editorState.resetCanvasOffset();
    final pos = root.position + Offset(-80, -250);
    editorState.moveCanvas(-pos);
  }

  Widget _iconButton({Widget icon, Function onPressed}) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }

  Widget _separator() {
    return SizedBox(
      width: 20,
      height: 40,
      child: VerticalDivider(
        indent: 8,
        endIndent: 8,
      ),
    );
  }
}
