import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import 'ast_node_view.dart';

class PrefabNodeView extends AstNodeView {
  @override
  Widget buildView(BuildContext context) {
    final node = Provider.of<Node>(context) as PrefabNode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: node.titleHeight,
          decoration: titleDecoration(Theme.of(context).secondaryHeaderColor),
          child: Center(
            child: Text(
              node.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          height: node.bodyHeight,
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Wrap(
            runSpacing: 10,
            children: [
              Text(node.description),
              Text('Flatten this prefab to edit and customize.'),
            ],
          ),
        ),
      ],
    );
  }
}
