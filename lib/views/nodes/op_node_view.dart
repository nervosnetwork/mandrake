import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/node.dart';
import 'ast_node_view.dart';

class OperationNodeView extends AstNodeView {
  @override
  Widget buildView(BuildContext context) {
    final _ = Provider.of<Node>(context) as OperationNode;
    return super.buildView(context);
  }
}
