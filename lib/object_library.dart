import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'models/node.dart';

class ObjectLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          right: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      padding: EdgeInsets.only(top: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 8,
        children: NodeTemplate.values.map((t) => _template(t)).toList(),
      ),
    );
  }

  Draggable<NodeTemplate> _template(NodeTemplate template) {
    final child = _NodeTemplateItem(
      template.title,
      FaIcon(template.icon, size: 20),
    );
    return Draggable<NodeTemplate>(
      child: child,
      feedback: _DragFeedbackObject(child),
      data: template,
      ignoringFeedbackSemantics: true,
    );
  }
}

class _NodeTemplateItem extends StatelessWidget {
  _NodeTemplateItem(this.title, this.icon);

  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      color: Colors.transparent, // To make the full area draggable
      width: 140,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(width: 22, child: icon),
          SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _DragFeedbackObject extends StatelessWidget {
  _DragFeedbackObject(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue[600], width: 1),
        ),
        child: child,
      ),
    );
  }
}

extension on NodeTemplate {
  String get title {
    final separated = describeEnum(this).split(RegExp(r'(?=[A-Z])')).join(' ');
    return separated[0].toUpperCase() + separated.substring(1);
  }

  IconData get icon {
    switch (this) {
      case NodeTemplate.value:
        return FontAwesomeIcons.font;
      case NodeTemplate.binaryOperator:
        return FontAwesomeIcons.plus;
      case NodeTemplate.not:
        return FontAwesomeIcons.notEqual;
      case NodeTemplate.cellOperator:
        return FontAwesomeIcons.database;
      case NodeTemplate.scriptOperator:
        return FontAwesomeIcons.code;
      case NodeTemplate.txOperator:
        return FontAwesomeIcons.codeBranch;
      case NodeTemplate.headerOperator:
        return FontAwesomeIcons.heading;
    }
    return FontAwesomeIcons.plus;
  }
}
