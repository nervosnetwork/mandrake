import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'property_editor.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';
import '../../models/command.dart';

class AstNodeInfoProperty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final doc = Provider.of<Document>(context, listen: false);
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
            DropdownButton(
              isDense: true,
              style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 13),
              onChanged: (value) {
                Command.updateValueType(doc, node, value).run();
              },
              value: node.valueType,
              items: node.exchangeableValueTypes.map((t) {
                return DropdownMenuItem(
                  child: Text(t.toString()),
                  value: t,
                );
              }).toList(),
            ),
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
    final selection = Provider.of<Selection>(context);
    final node = Provider.of<Node>(context) as AstNode;

    final onNodeActionItemSelected = (NodeActionItem item) {
      NodeActionExecutor(document, selection).execute(item.value);
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
