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
        return 'untitled';
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
    DocumentTemplate(DocumentTemplateType.udt),
    DocumentTemplate(DocumentTemplateType.balance),
  ];

  Document create() {
    switch (_type) {
      case DocumentTemplateType.blank:
        return _createDefaultDoc();
      case DocumentTemplateType.udt:
        return _createUdtDoc();
      case DocumentTemplateType.balance:
        return _createBlanceDoc();
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
    // TODO
    final root = RootNode();
    doc.addNode(root);

    doc.markNotDirty();
    return doc;
  }

  Document _createBlanceDoc() {
    final doc = Document(topLevelNodes: []);
    doc.fileName = 'balance';
    // TODO
    final root = RootNode();
    doc.addNode(root);

    doc.markNotDirty();
    return doc;
  }
}
