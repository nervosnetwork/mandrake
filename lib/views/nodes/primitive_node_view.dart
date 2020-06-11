import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import '../../utils/focus_helper.dart';
import 'ast_node_view.dart';

class PrimitiveNodeView extends AstNodeView {
  @override
  Widget buildView(BuildContext context) {
    final node = Provider.of<Node>(context) as PrimitiveNode;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text('Value:'),
                width: 50,
              ),
              _valueField(context, node),
            ],
          ),
        ),
      ],
    );
  }

  Widget _valueField(BuildContext context, PrimitiveNode node) {
    if (node.valueType == ValueType.bool) {
      return DropdownButton(
        isDense: true,
        onChanged: (value) {
          node.value = value;
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
      final maxLines = node.valueType == ValueType.uint64 ? 1 : 5;
      return Flexible(
        child: TextFormField(
          enabled: false, // isSelected(context), // Disable until we feel inline editing is smooth.
          controller: _valueController,
          style: Theme.of(context).textTheme.bodyText2,
          decoration: textFieldDecoration,
          onFieldSubmitted: (v) {
            FocusHelper.unfocus(context);
            node.value = v;
          },
          maxLines: maxLines,
          textInputAction: TextInputAction.next,
        ),
      );
    }

    return Text(node.value);
  }
}
