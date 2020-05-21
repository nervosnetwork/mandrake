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

  List<Widget> _templateWidgets(NodeTemplateGroupItem group) {
    return group.templates.map((t) => _template(t)).toList();
  }

  Widget _template(NT template) {
    final child = _NodeTemplateItem(template.title);
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Draggable<NT>(
        child: child,
        feedback: _DragFeedbackObject(child),
        data: template,
        ignoringFeedbackSemantics: true,
      ),
    );
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
      child: Text(title, style: TextStyle(fontSize: 12)),
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
  prefab, // Special sets of common operations as a single node (e.g. `balance`)
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

  List<NT> get templates {
    final map = {
      NodeTemplateGroup.operation: [
        NT(Value_Type.HASH),
        NT(Value_Type.SERIALIZE_TO_CORE),
        NT(Value_Type.SERIALIZE_TO_JSON),
        NT(Value_Type.NOT),
        NT(Value_Type.AND),
        NT(Value_Type.OR),
        NT(Value_Type.EQUAL),
        NT(Value_Type.LESS),
        NT(Value_Type.LEN),
        NT(Value_Type.SLICE),
        NT(Value_Type.INDEX),
        NT(Value_Type.ADD),
        NT(Value_Type.SUBTRACT),
        NT(Value_Type.MULTIPLY),
        NT(Value_Type.DIVIDE),
        NT(Value_Type.MOD),
        NT(Value_Type.COND),
        NT(Value_Type.TAIL_RECURSION),
      ],
      NodeTemplateGroup.prefab: [],
      NodeTemplateGroup.primitive: [
        NT(Value_Type.NIL),
        NT(Value_Type.UINT64),
        NT(Value_Type.BOOL),
        NT(Value_Type.BYTES),
        NT(Value_Type.ERROR),
        NT(Value_Type.ARG),
        NT(Value_Type.PARAM),
      ],
      NodeTemplateGroup.blockchain: [
        NT(Value_Type.OUT_POINT),
        NT(Value_Type.CELL_INPUT),
        NT(Value_Type.CELL_DEP),
        NT(Value_Type.SCRIPT),
        NT(Value_Type.CELL),
        NT(Value_Type.TRANSACTION),
        NT(Value_Type.HEADER),
      ],
      NodeTemplateGroup.list: [
        NT(Value_Type.APPLY),
        NT(Value_Type.REDUCE),
        NT(Value_Type.LIST),
        NT(Value_Type.QUERY_CELLS),
        NT(Value_Type.MAP),
        NT(Value_Type.FILTER),
      ],
      NodeTemplateGroup.cell: [
        NT(Value_Type.GET_CAPACITY),
        NT(Value_Type.GET_DATA),
        NT(Value_Type.GET_LOCK),
        NT(Value_Type.GET_TYPE),
        NT(Value_Type.GET_DATA_HASH),
        NT(Value_Type.GET_OUT_POINT),
      ],
      NodeTemplateGroup.script: [
        NT(Value_Type.GET_CODE_HASH),
        NT(Value_Type.GET_HASH_TYPE),
        NT(Value_Type.GET_ARGS),
      ],
      NodeTemplateGroup.transaction: [
        NT(Value_Type.GET_CELL_DEPS),
        NT(Value_Type.GET_HEADER_DEPS),
        NT(Value_Type.GET_INPUTS),
        NT(Value_Type.GET_OUTPUTS),
        NT(Value_Type.GET_WITNESSES),
      ],
      NodeTemplateGroup.header: [
        NT(Value_Type.GET_COMPACT_TARGET),
        NT(Value_Type.GET_TIMESTAMP),
        NT(Value_Type.GET_NUMBER),
        NT(Value_Type.GET_EPOCH),
        NT(Value_Type.GET_PARENT_HASH),
        NT(Value_Type.GET_TRANSACTIONS_ROOT),
        NT(Value_Type.GET_PROPOSALS_HASH),
        NT(Value_Type.GET_UNCLES_HASH),
        NT(Value_Type.GET_DAO),
        NT(Value_Type.GET_NONCE),
        NT(Value_Type.GET_HEADER),
      ],
    };
    return List<NT>.from(map[group]);
  }
}
