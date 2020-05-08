import 'package:flutter/material.dart';

import 'node_view.dart';

class RootNodeViewState extends NodeViewState {
  void _onAddCallButtonClicked() {
    throw UnimplementedError();
  }

  @override
  Widget buildView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: widget.node.titleHeight,
          decoration: titleDecoration(Colors.red),
          child: Center(
            child: Text(
              widget.node.name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        subtitle('Calls'),
        addChildButton(_onAddCallButtonClicked),
        subtitle('Streams'),
        addChildButton(),
      ],
    );
  }
}
