import 'dart:ui' show Offset;

import 'document.dart';
import 'node.dart';

enum DocumentTemplateType {
  blank,
  udt, // Simple UDT
  balance, // Get balance via default Secp256k1
}

extension on DocumentTemplateType {
  String get name {
    switch (this) {
      case DocumentTemplateType.blank:
        return 'Blank';
      case DocumentTemplateType.udt:
        return 'Simple UDT';
      case DocumentTemplateType.balance:
        return 'Balance';
    }
    return '';
  }

  String get description {
    switch (this) {
      case DocumentTemplateType.blank:
        return 'Default blank document';
      case DocumentTemplateType.udt:
        return 'Simple UDT: get balance and transfer';
      case DocumentTemplateType.balance:
        return 'Get balance for default Secp256k1 lock';
    }
    return '';
  }
}

class DocumentTemplate {
  DocumentTemplate(this._type);

  final DocumentTemplateType _type;
  String get name => _type.name;
  String get description => _type.description;

  static List<DocumentTemplate> templates = [
    DocumentTemplate(DocumentTemplateType.blank),
    DocumentTemplate(DocumentTemplateType.balance),
    DocumentTemplate(DocumentTemplateType.udt),
  ];

  Document create() {
    switch (_type) {
      case DocumentTemplateType.blank:
        return _createDefaultDoc();
      case DocumentTemplateType.udt:
        return _createUdtDoc();
      case DocumentTemplateType.balance:
        return _createBalanceDoc();
    }

    return null;
  }

  Document _createDefaultDoc() {
    final doc = Document(topLevelNodes: []);
    final root = RootNode();
    final callResult = NodeCreator.create(
      NodeTemplate(ValueType.uint64),
      root.position + Offset(root.size.width + 100, -50),
    );
    callResult.name = 'Call Result';
    root.addChild(callResult, root.addCallSlot('call result').id);
    doc.addNode(root);

    doc.markNotDirty();
    return doc;
  }

  Document _createUdtDoc() {
    final doc = Document(topLevelNodes: []);
    doc.fileName = 'simple_udt';

    final root = RootNode();
    root.name = 'simple udt';

    final udt = NodeCreator.create(
      NT(ValueType.prefabUdt),
      root.position + Offset(root.size.width + 100, -50),
    );
    udt.name = 'simple udt';
    root.addChild(udt, root.addCallSlot('ready').id);

    doc.addNode(root);
    doc.flattenPrefabNode(udt);

    final balance = doc.topLevelNodes.where((n) => n.name == 'balance').first;
    final transfer = doc.topLevelNodes.where((n) => n.name == 'transfer').first;

    doc.connectNode(
      parent: root,
      child: balance,
      slotId: root.addCallSlot('balance').id,
    );
    doc.connectNode(
      parent: root,
      child: transfer,
      slotId: root.addCallSlot('transfer').id,
    );

    doc.markNotDirty();
    return doc;
  }

  Document _createBalanceDoc() {
    final doc = Document(topLevelNodes: []);
    doc.fileName = 'balance';

    final root = RootNode();
    root.name = 'balance';

    final balance = PrefabNode(
      valueType: ValueType.prefabSecp256k1GetBalance,
      position: root.position + Offset(root.size.width + 100, -50),
    );
    balance.name = 'balance';
    root.addChild(balance, root.addCallSlot('balance').id);

    doc.addNode(root);
    doc.markNotDirty();
    return doc;
  }
}
