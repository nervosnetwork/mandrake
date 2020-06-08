import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'property_editor.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';

class RootNodePropertyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);
    final selection = Provider.of<Selection>(context);
    final node = Provider.of<Node>(context) as RootNode;

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
            title: 'Calls',
            children: [
              ...node.callSlots.map((e) => SlotProperty(e)).toList(),
            ],
          ),
          PropertyEditorSection(
            title: 'Streams',
            children: [
              ...node.streamSlots.map((e) => SlotProperty(e)).toList(),
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
