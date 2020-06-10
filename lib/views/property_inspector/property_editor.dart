import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document.dart';
import '../../models/node.dart';

class PropertyEditorSection extends StatelessWidget {
  PropertyEditorSection({@required this.title, @required this.children, Key key}) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        ),
        Divider(height: 2),
      ],
    );
  }
}

class PropertyEditorTextFieldDecoration extends InputDecoration {
  PropertyEditorTextFieldDecoration()
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

class BasicInfoProperty extends StatelessWidget {
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
                decoration: PropertyEditorTextFieldDecoration(),
                onFieldSubmitted: (v) {
                  node.name = v;
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
                decoration: PropertyEditorTextFieldDecoration().copyWith(suffixText: 'x'),
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
                decoration: PropertyEditorTextFieldDecoration().copyWith(suffixText: 'y'),
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
class SlotProperty extends StatelessWidget {
  SlotProperty(this.slot);

  final ChildSlot slot;

  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context, listen: false);
    final node = Provider.of<Node>(context);

    void _deleteSlot(ChildSlot slot) {
      if (slot.childId != null) {
        document.disconnectNode(parent: node, childId: slot.childId);
      }
      node.removeSlot(slot.id);
    }

    void _deleteChild(ChildSlot slot) {
      document.disconnectNode(parent: node, childId: slot.childId);
    }

    return Container(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if (node.canRemoveSlot) {
                _deleteSlot(slot);
              }
            },
            child: Icon(
              node.canRemoveSlot ? Icons.highlight_off : null,
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
