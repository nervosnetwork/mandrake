import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'property_editor.dart';
import 'ast_node_property_editor.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';
import '../../models/command.dart';
import '../../utils/focus_helper.dart';

class PrimitiveNodePropertyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);
    final selection = Provider.of<Selection>(context);
    final node = Provider.of<Node>(context) as PrimitiveNode;

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
            title: 'Value',
            children: [
              _valueField(context, node),
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

  Widget _valueField(BuildContext context, PrimitiveNode node) {
    final doc = Provider.of<Document>(context, listen: false);
    if (node.valueType == ValueType.bool) {
      return DropdownButton(
        isDense: true,
        onChanged: (value) {
          Command.updateValue(doc, node, value).run();
        },
        value: node.value,
        items: [
          DropdownMenuItem(
            child: Text('true'),
            value: 'true',
          ),
          DropdownMenuItem(
            child: Text('false'),
            value: 'false',
          ),
        ],
      );
    }

    if (node.editableAsText) {
      final _valueController = TextEditingController();
      _valueController.text = node.value;
      return Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: _valueController,
              style: Theme.of(context).textTheme.bodyText2,
              decoration: PropertyEditorTextFieldDecoration(),
              onFieldSubmitted: (v) {
                FocusHelper.unfocus(context);
                Command.updateValue(doc, node, v).run();
              },
              maxLines: node.allowedEditLines,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      );
    }

    return Text(node.value);
  }
}
