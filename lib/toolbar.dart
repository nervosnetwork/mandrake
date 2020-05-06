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
            SizedBox(
              width: 40,
              child: Text(
                '${(editorState.zoomScale * 100).round().toInt()}%',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.zoom_in),
              onPressed: editorState.zoomInAction,
            ),
            IconButton(
              icon: Icon(Icons.zoom_out),
              onPressed: editorState.zoomOutAction,
            ),
          ],
        ),
      );
    });
  }
}
