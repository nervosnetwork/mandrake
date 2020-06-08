import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/editor_state.dart';

class Toolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditorState>(builder: (context, editorState, child) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(width: 20),
            _iconButton(
              icon: Icon(Icons.note_add),
              onPressed: null,
            ),
            _iconButton(
              icon: Icon(Icons.file_download),
              onPressed: null,
            ),
            _iconButton(
              icon: Icon(Icons.file_upload),
              onPressed: null,
            ),
            _separator(),
            _iconButton(
              icon: Icon(Icons.zoom_out),
              onPressed: editorState.zoomOutAction,
            ),
            SizedBox(
              width: 30,
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
          ],
        ),
      );
    });
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
