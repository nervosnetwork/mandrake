import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import 'node_view.dart';

class RootNodeView extends NodeView {
  @override
  Widget buildView(BuildContext context) {
    final node = Provider.of<Node>(context) as RootNode;

    void _onAddCallButtonClicked() => node.addCallSlot();
    void _onAddStreamButtonClicked() => node.addStreamSlot();

    final callSlots = node.callSlots.map((s) => slot(context, s)).toList();
    final streamSlots = node.streamSlots.map((s) => slot(context, s)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: node.titleHeight,
          decoration: titleDecoration(Theme.of(context).primaryColor),
          child: Center(
            child: Text(
              node.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        subtitle(context, 'Calls'),
        ...callSlots,
        addChildButton(context, _onAddCallButtonClicked),
        subtitle(context, 'Streams'),
        ...streamSlots,
        addChildButton(context, _onAddStreamButtonClicked),
      ],
    );
  }
}
