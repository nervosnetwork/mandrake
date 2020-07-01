import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/node.dart';

class ObjectLibrary extends StatefulWidget {
  @override
  _ObjectLibraryState createState() => _ObjectLibraryState();
}

class _ObjectLibraryState extends State<ObjectLibrary> {
  List<_NodeTemplateGroupItem> _groups;

  @override
  void initState() {
    super.initState();

    _groups = NodeTemplateGroup.values.map((g) => _NodeTemplateGroupItem(g)).toList();
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
                    Text(g.title, style: Theme.of(context).textTheme.subtitle2),
                  ],
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: _templateWidgets(g),
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

  List<Widget> _templateWidgets(_NodeTemplateGroupItem group) {
    return group.templates.map((template) {
      final child = _NodeTemplateItem(template.title);
      return Padding(
        padding: const EdgeInsets.all(1),
        child: Draggable<NodeTemplate>(
          child: child,
          feedback: _DragFeedbackObject(child),
          data: template,
          ignoringFeedbackSemantics: true,
        ),
      );
    }).toList();
  }
}

class _NodeTemplateItem extends StatelessWidget {
  _NodeTemplateItem(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      color: Colors.transparent, // To make the full area draggable
      width: 150,
      child: Text(title, style: Theme.of(context).textTheme.bodyText2),
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

class _NodeTemplateGroupItem {
  _NodeTemplateGroupItem(this.group) : isExpanded = group == NodeTemplateGroup.values.first;

  final NodeTemplateGroup group;
  bool isExpanded;

  String get title {
    final separated = describeEnum(group).split(RegExp(r'(?=[A-Z])')).join(' ');
    return separated[0].toUpperCase() + separated.substring(1);
  }

  IconData get icon {
    final map = {
      NodeTemplateGroup.operation: Icons.iso,
      NodeTemplateGroup.prefab: Icons.domain,
      NodeTemplateGroup.primitive: Icons.looks_one,
      NodeTemplateGroup.blockchain: Icons.dashboard,
      NodeTemplateGroup.list: Icons.list,
      NodeTemplateGroup.cell: Icons.blur_circular,
      NodeTemplateGroup.script: Icons.code,
      NodeTemplateGroup.transaction: Icons.blur_linear,
      NodeTemplateGroup.header: Icons.hdr_on,
    };
    return map[group] ?? Icons.fiber_new;
  }

  List<NodeTemplate> get templates {
    return List<NodeTemplate>.from(NodeTemplate.grouped[group]);
  }
}
