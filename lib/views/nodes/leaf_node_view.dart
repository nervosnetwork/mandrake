import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import 'ast_node_view.dart';

class LeafNodeView extends AstNodeView {
  @override
  Widget buildView(BuildContext context) {
    final node = Provider.of<Node>(context) as LeafNode;

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
          height: node.bodyHeight,
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            children: [
              Container(
                child: Text('Value:'),
                width: 50,
              ),
              Text(node.value),

              /// TODO: different controls for different types. e.g.:
              ///   dropdown for bool: true/false
              ///   plain text for nil: nil
              ///   editable text field for values
              ///   etc.
            ],
          ),
        ),
      ],
    );
  }
}
