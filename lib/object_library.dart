import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'models/node.dart';

class ObjectLibrary extends StatefulWidget {
  @override
  _ObjectLibraryState createState() => _ObjectLibraryState();
}

class _ObjectLibraryState extends State<ObjectLibrary> {
  List<NodeTemplateGroupItem> _groups;

  @override
  void initState() {
    super.initState();

    _groups = NodeTemplateGroup.values.map((g) => NodeTemplateGroupItem(g)).toList();
  }

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
      child: SingleChildScrollView(
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.symmetric(vertical: 0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _groups[index].isExpanded = !isExpanded;
            });
          },
          children: _groups.map((g) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 40, child: Center(child: FaIcon(g.icon, size: 20))),
                    Text(g.title, style: TextStyle(fontSize: 12)),
                  ],
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: _templateWidgets(g.templates),
                ),
              ),
              isExpanded: g.isExpanded,
              canTapOnHeader: true,
            );
          }).toList(),
        ),
      ),
    );
  }

  List<Widget> _templateWidgets(List<NodeTemplate> templates) {
    return templates.map((t) => _template(t)).toList();
  }

  Widget _template(NodeTemplate template) {
    final child = _NodeTemplateItem(
      template.title,
      FaIcon(template.icon, size: 20),
    );
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Draggable<NodeTemplate>(
        child: child,
        feedback: _DragFeedbackObject(child),
        data: template,
        ignoringFeedbackSemantics: true,
      ),
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
      padding: EdgeInsets.all(6),
      color: Colors.transparent, // To make the full area draggable
      width: 140,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // SizedBox(width: 22, child: icon),
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

enum NodeTemplateGroup {
  primitive,
  cell,
  script,
  transaction,
  header,
}

class NodeTemplateGroupItem {
  NodeTemplateGroupItem(this.group) : isExpanded = group == NodeTemplateGroup.values.first;

  final NodeTemplateGroup group;
  bool isExpanded;

  String get title {
    final separated = describeEnum(group).split(RegExp(r'(?=[A-Z])')).join(' ');
    return separated[0].toUpperCase() + separated.substring(1);
  }

  IconData get icon {
    switch (group) {
      case NodeTemplateGroup.primitive:
        return FontAwesomeIcons.font;
      case NodeTemplateGroup.cell:
        return FontAwesomeIcons.database;
      case NodeTemplateGroup.script:
        return FontAwesomeIcons.code;
      case NodeTemplateGroup.transaction:
        return FontAwesomeIcons.codeBranch;
      case NodeTemplateGroup.header:
        return FontAwesomeIcons.heading;
    }
    return FontAwesomeIcons.plus;
  }

  List<NodeTemplate> get templates {
    // TODO: return real list
    return NodeTemplate.values;
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
