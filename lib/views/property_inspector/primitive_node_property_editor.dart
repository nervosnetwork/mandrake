import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'property_editor.dart';
import 'ast_node_property_editor.dart';

import '../../models/document.dart';
import '../../models/node.dart';
import '../../models/node_action.dart';
import '../../utils/focus_helper.dart';

class PrimitiveNodePropertyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context);
    final node = Provider.of<Node>(context) as PrimitiveNode;

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
              _valueField(context, node),
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

  Widget _valueField(BuildContext context, PrimitiveNode node) {
    if (node.valueType == Value_Type.BOOL) {
      return DropdownButton(
        isDense: true,
        onChanged: (value) {
          node.setValue(value);
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

    if ([Value_Type.BYTES, Value_Type.UINT64, Value_Type.ERROR].contains(node.valueType)) {
      final _valueController = TextEditingController();
      _valueController.text = node.value;
      final maxLines = node.valueType == Value_Type.UINT64 ? 1 : 5;
      return Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: _valueController,
              style: Theme.of(context).textTheme.bodyText2,
              decoration: PropertyEditorTextFieldDecoration(),
              onFieldSubmitted: (v) {
                FocusHelper.unfocus(context);
                node.setValue(v);
              },
              maxLines: maxLines,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      );
    }

    /// TODO: more edit fields

    return Text(node.value);
  }
}
