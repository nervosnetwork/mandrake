import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document.dart';
import '../../models/node.dart';
import '../../models/command.dart';
import 'node_view.dart';

class RootNodeView extends NodeView {
  @override
  Widget buildView(BuildContext context) {
    final doc = Provider.of<Document>(context, listen: false);
    final node = Provider.of<Node>(context) as RootNode;

    void _onAddCallButtonClicked() => Command.addCallSlot(doc, node).run();
    void _onAddStreamButtonClicked() => Command.addStreamSlot(doc, node).run();

    final callSlots = node.callSlots.map((s) => slot(context, s)).toList();
    final streamSlots = node.streamSlots.map((s) => slot(context, s)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: node.titleHeight,
          decoration: titleDecoration(Color.fromARGB(255, 59, 198, 138)),
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
