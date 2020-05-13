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
        child: ChangeNotifierProvider<Node>.value(
          value: node,
          child: _propertyEditor(node),
        ),
      );
    });
  }

  Widget _propertyEditor(Node node) {
    if (node is RootNode) {
      return _RootNodePropertyEditor();
    }

    if (node != null) {
      return _NodePropertyEditor();
    }

    return Center(
      child: const Text(
        'No Selection',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  _Section({@required this.title, @required this.children, Key key}) : super(key: key);

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
  _SectionDivider() : super(height: 2);
}

class _TextFieldDecoration extends InputDecoration {
  _TextFieldDecoration()
      : super(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          isDense: true,
        );
}

class _TextFieldRowSpacer extends SizedBox {
  _TextFieldRowSpacer() : super(height: 4);
}

class _BasicInfoProperty extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _xPosController = TextEditingController();
  final TextEditingController _yPosController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context, listen: false);
    final node = Provider.of<Node>(context);

    _nameController.text = node.name;
    _xPosController.text = node.position.dx.toInt().toString();
    _yPosController.text = node.position.dy.toInt().toString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              child: Text('Name'),
              width: 60,
            ),
            Flexible(
              child: TextFormField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: _TextFieldDecoration(),
                onFieldSubmitted: (v) {
                  node.updateName(v); // TODO: simple validation
                },
              ),
            ),
          ],
        ),
        _TextFieldRowSpacer(),
        Row(
          children: [
            Container(
              child: Text('Position'),
              width: 60,
            ),
            Flexible(
              child: TextFormField(
                controller: _xPosController,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: _TextFieldDecoration().copyWith(suffixText: 'x'),
                onFieldSubmitted: (v) {
                  // TODO: simple validation
                  document.moveNodePosition(node, Offset(double.parse(v) - node.position.dx, 0));
                },
              ),
            ),
            SizedBox(width: 5),
            Flexible(
              child: TextFormField(
                controller: _yPosController,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: _TextFieldDecoration().copyWith(suffixText: 'y'),
                onFieldSubmitted: (v) {
                  // TODO: simple validation
                  document.moveNodePosition(node, Offset(0, double.parse(v) - node.position.dy));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// TODO: editing call name.
class _SlotProperty extends StatelessWidget {
  _SlotProperty(this.slot);

  final ChildSlot slot;

  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context, listen: false);
    final node = Provider.of<Node>(context);

    void _deleteSlot(ChildSlot slot) {
      if (slot.child_id != null) {
        document.disconnectNode(parent: node, child_id: slot.child_id);
      }
      node.removeSlot(slot.id);
    }

    void _deleteChild(ChildSlot slot) {
      document.disconnectNode(parent: node, child_id: slot.child_id);
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
  @override
  Widget build(BuildContext context) {
    final node = Provider.of<Node>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'Info',
          children: [
            _BasicInfoProperty(),
          ],
        ),
        _SectionDivider(),
        _Section(
          title: 'Children',
          children: [
            ...node.slots.map((e) => _SlotProperty(e)).toList(),
          ],
        ),
        _SectionDivider(),
      ],
    );
  }
}

class _RootNodePropertyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final node = Provider.of<Node>(context) as RootNode;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'Info',
          children: [
            _BasicInfoProperty(),
          ],
        ),
        _SectionDivider(),
        _Section(
          title: 'Calls',
          children: [
            ...node.callSlots.map((e) => _SlotProperty(e)).toList(),
          ],
        ),
        _SectionDivider(),
        _Section(
          title: 'Streams',
          children: [
            ...node.streamSlots.map((e) => _SlotProperty(e)).toList(),
          ],
        ),
        _SectionDivider(),
      ],
    );
  }
}
