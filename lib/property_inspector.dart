import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document.dart';
import 'models/selection.dart';
import 'models/node.dart';

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
        child: _propertyEditor(node),
      );
    });
  }

  Widget _propertyEditor(Node node) {
    if (node is RootNode) {
      return _RootNodePropertyEditor(node);
    }

    if (node != null) {
      return _NodePropertyEditor(node);
    }

    return Center(
      child: Text(
        'No Selection',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  _Section({this.title, this.children, Key key}) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 5),
            ...children,
          ]),
    );
  }
}

class _SectionDivider extends Divider {
  _SectionDivider() : super(height: 1);
}

class _RootNodePropertyEditor extends StatelessWidget {
  _RootNodePropertyEditor(this.node);

  final RootNode node;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'Calls',
          children: [
            ...node.callSlots.map((e) => _slot(e, context)).toList(),
          ],
        ),
        _SectionDivider(),
        _Section(
          title: 'Streams',
          children: [
            ...node.streamSlots.map((e) => _slot(e, context)).toList(),
          ],
        ),
        _SectionDivider(),
      ],
    );
  }

  Widget _slot(ChildSlot slot, BuildContext context) {
    final document = Provider.of<Document>(context, listen: false);
    final selection = Provider.of<Selection>(context, listen: false);

    void _deleteSlot(ChildSlot slot) {
      if (slot.child_id != null) {
        document.disconnectNode(parent: node, child_id: slot.child_id);
      }
      node.removeSlot(slot.id);
      selection.invalidate();
    }

    void _deleteChild(ChildSlot slot) {
      document.disconnectNode(parent: node, child_id: slot.child_id);
      selection.invalidate();
    }

    return Container(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              _deleteSlot(slot);
            },
            child: Icon(
              Icons.highlight_off,
              color: Colors.grey,
              size: 15,
            ),
          ),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              if (slot.isConnected) {
                _deleteChild(slot);
              }
            },
            child: Icon(
              slot.isConnected ? Icons.link_off : null,
              color: Colors.grey,
              size: 15,
            ),
          ),
          SizedBox(width: 4),
          Container(
            child: Text(
              slot.name,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _NodePropertyEditor extends StatelessWidget {
  _NodePropertyEditor(this.node);

  final Node node;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'Children',
          children: [],
        ),
        _SectionDivider(),
      ],
    );
  }
}
