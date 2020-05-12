import 'package:flutter/material.dart';

import '../../models/node.dart';
import 'node_view.dart';

class RootNodeViewState extends NodeViewState {
  void _onAddCallButtonClicked() {
    setState(() {
      _root.addCallSlot();
    });
  }

  void _onAddStreamButtonClicked() {
    setState(() {
      _root.addStreamSlot();
    });
  }

  RootNode get _root => widget.node;

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
        ..._callSlots(),
        addChildButton(_onAddCallButtonClicked),
        subtitle('Streams'),
        ..._streamSlots(),
        addChildButton(_onAddStreamButtonClicked),
      ],
    );
  }

  List<Widget> _callSlots() => _root.callSlots.map((s) => slot(s)).toList();

  List<Widget> _streamSlots() => _root.streamSlots.map((s) => slot(s)).toList();
}
