import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document.dart';
import '../../models/node.dart';
import '../../models/undo_manager.dart';

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
                  node.position = node.position + Offset(double.parse(v) - node.position.dx, 0);
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
                  Command.movePosition(
                    node,
                    node.position + Offset(0, double.parse(v) - node.position.dy),
                  ).run();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SlotProperty extends StatelessWidget {
  SlotProperty(this.slot);

  final ChildSlot slot;

  @override
  Widget build(BuildContext context) {
    final document = Provider.of<Document>(context, listen: false);
    final node = Provider.of<Node>(context);
    final nameController = TextEditingController();
    nameController.text = slot.name;

    void deleteSlot() {
      Command.deleteSlot(document, node, slot).run();
    }

    void disconnectChild() {
      Command.disconnectChildren(document, node).run();
    }

    void renameSlot(String name) {
      Command.renameSlot(node, slot, name).run();
    }

    return Container(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              if (node.canRemoveSlot) {
                deleteSlot();
              }
            },
            child: Icon(
              node.canRemoveSlot ? Icons.highlight_off : null,
              color: Colors.grey,
              size: 18,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (slot.isConnected) {
                disconnectChild();
              }
            },
            child: Icon(
              slot.isConnected ? Icons.link_off : null,
              color: Colors.grey,
              size: 18,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: nameController,
              style: Theme.of(context).textTheme.bodyText2,
              decoration: PropertyEditorTextFieldDecoration(),
              onFieldSubmitted: (v) {
                renameSlot(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}
