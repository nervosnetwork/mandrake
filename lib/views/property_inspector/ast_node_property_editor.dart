import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'property_editor.dart';

import '../../models/document.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';

class AstNodeInfoProperty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final node = Provider.of<Node>(context) as AstNode;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              child: Text('Type'),
              width: 60,
            ),
            Text(node.valueType.toString()),
          ],
        ),
      ],
    );
  }
}

class AstNodePropertyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);
    final node = Provider.of<Node>(context) as AstNode;

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
            title: 'Ast Info',
            children: [
              AstNodeInfoProperty(),
            ],
          ),
          PropertyEditorSection(
            title: 'Children',
            children: [
              ...node.slots.map((e) => SlotProperty(e)).toList(),
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
