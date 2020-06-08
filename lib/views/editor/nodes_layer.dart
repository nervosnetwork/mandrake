import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document.dart';
import '../../models/selection.dart';
import '../../models/node.dart';

import '../node.dart';

class NodesLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Document, Selection>(
      builder: (context, document, selection, child) {
        return Stack(
          overflow: Overflow.visible,
          children: document.nodes.map((node) {
            return ChangeNotifierProvider<Node>.value(
              value: node,
              child: ViewCreator.create(node),
            );
          }).toList(),
        );
      },
    );
  }
}
