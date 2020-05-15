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
        children: _templates,
      ),
    );
  }

  /// These categories are not scientific work.
  List<Widget> get _templates {
    return [
      _template(
        'Binary Operation',
        _icon(FontAwesomeIcons.plus),
        AstNodeKind.op,
        Value_Type.ADD,
      ),
      _template(
        'Not',
        _icon(FontAwesomeIcons.notEqual),
        AstNodeKind.op,
        Value_Type.NOT,
      ),
      _template(
        'Cell Operation',
        _icon(FontAwesomeIcons.database),
        AstNodeKind.cellGetOp,
        Value_Type.GET_CAPACITY,
      ),
      _template(
        'Script Operation',
        _icon(FontAwesomeIcons.code),
        AstNodeKind.scriptGetOp,
        Value_Type.GET_CODE_HASH,
      ),
      _template(
        'Tx Operation',
        _icon(FontAwesomeIcons.codeBranch),
        AstNodeKind.txGetOp,
        Value_Type.GET_INPUTS,
      ),
      _template(
        'Header Operation',
        _icon(FontAwesomeIcons.heading),
        AstNodeKind.headerGetOp,
        Value_Type.GET_NUMBER,
      ),
    ];
  }

  Draggable<NodeMeta> _template(
    String title,
    Widget icon,
    AstNodeKind astKind,
    Value_Type valueType,
  ) {
    final child = _NodeTemplate(title, icon);
    return Draggable<NodeMeta>(
      child: child,
      feedback: _DragFeedbackObject(child),
      data: NodeMeta(astKind, valueType),
      ignoringFeedbackSemantics: true,
    );
  }

  Widget _icon(IconData icon) => FaIcon(icon, size: 20);
}

class _NodeTemplate extends StatelessWidget {
  _NodeTemplate(this.title, this.icon);

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
