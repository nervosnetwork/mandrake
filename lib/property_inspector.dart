import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document.dart';
import 'models/selection.dart';
import 'models/node.dart';

import 'views/property_inspector/root_node_property_editor.dart';
import 'views/property_inspector/ast_node_property_editor.dart';
import 'views/property_inspector/primitive_node_property_editor.dart';
import 'views/property_inspector/prefab_node_property_editor.dart';

class PropertyInspector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Selection>(builder: (context, selection, child) {
      final document = Provider.of<Document>(context, listen: false);
      final node = selection.selectedNode(document.nodes);

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Border(
            left: BorderSide(
              width: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: ChangeNotifierProvider<Node>.value(
          value: node,
          child: _propertyEditor(node),
        ),
      );
    });
  }

  Widget _propertyEditor(Node node) {
    if (node is RootNode) {
      return RootNodePropertyEditor();
    }

    if (node is PrimitiveNode) {
      return PrimitiveNodePropertyEditor();
    }

    if (node is PrefabNode) {
      return PrefabNodePropertyEditor();
    }

    if (node is AstNode) {
      return AstNodePropertyEditor();
    }

    if (node != null) {
      assert(false, 'No special node property editor implemented.');
    }

    return Center(
      child: const Text(
        'No Selection',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
