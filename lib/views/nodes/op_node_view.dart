import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import 'ast_node_view.dart';

class OperationNodeView extends AstNodeView {
  @override
  Widget buildView(BuildContext context) {
    final _ = Provider.of<Node>(context) as OperationNode;
    return super.buildView(context);

    /* TODO
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: node.titleHeight,
          decoration: titleDecoration(Theme.of(context).accentColor),
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
          child: Text('todo'),
        ),
      ],
    );
  */
  }
}
