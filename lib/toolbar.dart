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
        child: Row(
          children: [
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.note_add),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: null,
            ),
            _separator(),
            IconButton(
              icon: Icon(Icons.zoom_out),
              onPressed: editorState.zoomOutAction,
            ),
            SizedBox(
              width: 30,
              child: Text(
                '${(editorState.zoomScale * 100).round().toInt()}%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.zoom_in),
              onPressed: editorState.zoomInAction,
            ),
          ],
        ),
      );
    });
  }

  Widget _separator() {
    return SizedBox(
      width: 20,
      child: VerticalDivider(
        indent: 8,
        endIndent: 8,
      ),
    );
  }
}
