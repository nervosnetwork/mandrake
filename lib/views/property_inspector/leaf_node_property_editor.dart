import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'property_editor.dart';
import 'ast_node_property_editor.dart';

import '../../models/document.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';

class LeafNodePropertyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);
    final node = Provider.of<Node>(context) as LeafNode;

    final onNodeActionItemSelected = (NodeActionItem item) {
      NodeActionExecutor(document, node).execute(item.value);
    };

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyEditorSection(
            title: 'Info',
            children: [
              BasicInfoProperty(),
            ],
          ),
          PropertyEditorSection(
            title: 'Value',
            children: [
              // TODO: value editing section
              Text(node.value + ' todo:'),
            ],
          ),
          PropertyEditorSection(
            title: 'Ast Info',
            children: [
              AstNodeInfoProperty(),
            ],
          ),
          PropertyEditorSection(
            title: 'Actions',
            children: NodeActionBuilder(document, node).build().map((action) {
              return OutlineButton(
                child: Text(
                  action.label,
                  style: TextStyle(
                    color: action.danger ? Colors.red : null,
                  ),
                ),
                onPressed: () {
                  onNodeActionItemSelected(action);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
