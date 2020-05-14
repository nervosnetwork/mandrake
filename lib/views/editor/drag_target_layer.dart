import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';

/// Accept dragged node template from Object Panel.
class DragTargetLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context, listen: false);
    final selection = Provider.of<Selection>(context, listen: false);

    return DragTarget<NodeMeta>(
      onWillAccept: (data) => data != null,
      onAcceptWithDetails: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final pos = renderBox.globalToLocal(details.offset);
        final node = NodeCreator.create(details.data, pos);
        document.addNode(node);
        selection.select(node);
      },
      builder: (context, candidateData, rejectedData) => Container(),
    );
  }
}
