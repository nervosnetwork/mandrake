import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import '../../models/selection.dart';
import 'node_view.dart';

class RootNodeView extends NodeView {
  RootNodeView(Selection selection) : super(selection);

  void _onAddCallButtonClicked() {
    /*
    setState(() {
      _root.addCallSlot();
    });
    widget.selection.invalidate();*/
  }

  void _onAddStreamButtonClicked() {
    /*
    setState(() {
      _root.addStreamSlot();
    });
    widget.selection.invalidate();*/
  }

  @override
  Widget buildView(BuildContext context) {
    final node = Provider.of<Node>(context) as RootNode;

    final callSlots = node.callSlots.map((s) => slot(node, s)).toList();

    final streamSlots = node.streamSlots.map((s) => slot(node, s)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: node.titleHeight,
          decoration: titleDecoration(Colors.red),
          child: Center(
            child: Text(
              node.name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        subtitle(node, 'Calls'),
        ...callSlots,
        addChildButton(context, node, _onAddCallButtonClicked),
        subtitle(node, 'Streams'),
        ...streamSlots,
        addChildButton(context, node, _onAddStreamButtonClicked),
      ],
    );
  }
}
