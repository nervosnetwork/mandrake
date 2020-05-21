import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                    SizedBox(width: 40, child: Center(child: Icon(g.icon, size: 20))),
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
      Icon(template.icon, size: 20),
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
  operation,
  primitive,
  blockchain,
  list,
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
      case NodeTemplateGroup.operation:
        return Icons.iso;
      case NodeTemplateGroup.primitive:
        return Icons.looks_one;
      case NodeTemplateGroup.blockchain:
        return Icons.dashboard;
      case NodeTemplateGroup.list:
        return Icons.list;
      case NodeTemplateGroup.cell:
        return Icons.blur_circular;
      case NodeTemplateGroup.script:
        return Icons.code;
      case NodeTemplateGroup.transaction:
        return Icons.blur_linear;
      case NodeTemplateGroup.header:
        return Icons.hdr_on;
    }
    return Icons.fiber_new;
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
    return Icons.fiber_new;
  }
}
