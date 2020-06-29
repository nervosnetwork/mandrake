import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'property_editor.dart';
import 'ast_node_property_editor.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';
import '../../utils/focus_helper.dart';

class PrefabNodePropertyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);
    final selection = Provider.of<Selection>(context);
    final node = Provider.of<Node>(context) as PrefabNode;

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
            title: 'Prefab Settings',
            children: _valuesEditor(context, node),
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

  List<Widget> _valuesEditor(BuildContext context, PrefabNode node) {
    return node.values.map((value) {
      final _valueController = TextEditingController();
      _valueController.text = value.value;
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.name,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _valueController,
                          style: Theme.of(context).textTheme.bodyText2,
                          decoration: PropertyEditorTextFieldDecoration(),
                          maxLines: 2,
                          onFieldSubmitted: (v) {
                            FocusHelper.unfocus(context);
                            node.updateValue(value.name, v);
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
          Divider(height: 2),
        ],
      );
    }).toList();
  }
}
