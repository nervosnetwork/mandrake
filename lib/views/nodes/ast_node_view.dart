import 'package:flutter/material.dart';

import 'node_view.dart';

class AstNodeView extends NodeView {
  @override
  Widget buildView(BuildContext context) => super.buildView(context);

  InputDecoration get textFieldDecoration => _AstNodeTextFieldDecoration();
}

class _AstNodeTextFieldDecoration extends InputDecoration {
  _AstNodeTextFieldDecoration()
      : super(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          isDense: true,
        );
}
