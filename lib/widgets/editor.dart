import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/document.dart';
import '../models/document_template.dart';
import '../models/selection.dart';
import '../models/editor_state.dart';
import '../models/recent_files.dart';
import '../models/undo_manager.dart';

import '../io/file_chooser.dart';
import '../io/doc_reader.dart';
import '../io/doc_writer.dart';
import '../io/ast_writer.dart';

import 'toolbar.dart';
import 'object_library.dart';
import 'property_inspector.dart';
import 'ruler.dart';

import '../views/editor/editor_dimensions.dart';
import '../views/editor/canvas_layer.dart';
import '../views/editor/edges_layer.dart';
import '../views/editor/nodes_layer.dart';
import '../views/editor/pointer_layer.dart';

class Editor extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  Document doc;
  FileHandle docHandle;
  Selection selection;
  EditorState editorState;
  RecentFiles recentFiles;

  void resetState() {
    selection = Selection();
    editorState = EditorState();
    UndoManager.shared().clear();
  }

  void newDocument() {
    promptToSaveIfNecessary(() {
      setState(() {
        doc = DocumentTemplate(DocumentTemplateType.blank).create();
        docHandle = null;
        resetState();
      });
    });
  }

  void newDocumentFromTemplate() {
    promptToSaveIfNecessary(() {
      showTemplateDialog();
    });
  }

  Future<void> showTemplateDialog({Function dangerAction, bool cancellable = true}) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var selectedTemplate = DocumentTemplate.templates.first;
        return AlertDialog(
          title: Text('Choose a template'),
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: 800,
              height: 400,
              child: Column(
                children: DocumentTemplate.templates.map((template) {
                  return RadioListTile<DocumentTemplate>(
                    title: Text(template.name),
                    subtitle: Text(template.description),
                    value: template,
                    groupValue: selectedTemplate,
                    onChanged: (DocumentTemplate value) {
                      setState(() {
                        selectedTemplate = value;
                      });
                    },
                  );
                }).toList(),
              ),
            );
          }),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: cancellable
                  ? () {
                      Navigator.pop(context, null);
                    }
                  : null,
            ),
            FlatButton(
              child: Text('Create'),
              onPressed: () {
                Navigator.pop(context, selectedTemplate);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        doc = result.create();
        docHandle = null;
        resetState();
      });
    }
  }

  void openDocument() {
    promptToSaveIfNecessary(() async {
      final handle = await showOpenPanel(
        allowedFileTypes: [
          FileFilterGroup(extensions: ['json'], label: 'JSON')
        ],
      );

      if (handle == null) {
        return;
      }

      final docRead = await DocReader(handle).read();
      if (docRead != null) {
        setState(() {
          doc = docRead;
          doc.rebuild();
          doc.markNotDirty();
          docHandle = handle;
          trackRecentFile(handle);
          resetState();
        });
      }
    });
  }

  void openDocumentHandle(FileHandle handle) {
    promptToSaveIfNecessary(() async {
      final docRead = await DocReader(handle).read();
      if (docRead != null) {
        setState(() {
          doc = docRead;
          doc.rebuild();
          doc.markNotDirty();
          docHandle = handle;
          trackRecentFile(handle);
          resetState();
        });
      }
    });
  }

  Future<bool> saveDocument() async {
    if (docHandle == null) {
      final handle = await showSavePanel(
        suggestedFileName: doc.fileName,
        allowedFileTypes: [
          FileFilterGroup(extensions: ['json'], label: 'JSON')
        ],
      );
      if (handle != null) {
        docHandle = handle;
        trackRecentFile(handle);
      }
    }

    if (docHandle != null) {
      await DocWriter(doc, docHandle).write();
      doc.markNotDirty();
      return true;
    }
    return false;
  }

  Future<bool> saveDocumentAs() async {
    final handle = await showSavePanel(
      suggestedFileName: doc.fileName,
      allowedFileTypes: [
        FileFilterGroup(extensions: ['json'], label: 'JSON')
      ],
    );
    if (handle != null) {
      docHandle = handle;
      trackRecentFile(handle);
    }

    if (docHandle != null) {
      await DocWriter(doc, docHandle).write();
      doc.markNotDirty();
      return true;
    }
    return false;
  }

  void exportAst() async {
    final handle = await showSavePanel(
      suggestedFileName: 'ast.bin',
    );

    if (handle != null) {
      await AstWriter(doc, handle).write();
    }
  }

  void trackRecentFile(FileHandle fileHandle) async {
    await recentFiles.push(fileHandle);
  }

  Future<void> promptToSaveIfNecessary(Function dangerAction) async {
    if (!doc.isDirty) {
      return dangerAction();
    }

    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unsaved document'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("There're unsaved changes. Do you want to save the current document first?"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes, save the document.'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text('No, discard the changes.'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (result) {
      if (await saveDocument()) {
        dangerAction();
      }
    } else {
      dangerAction();
    }
  }

  @override
  void initState() {
    doc = Document();
    docHandle = null;
    resetState();
    recentFiles = RecentFiles();
    recentFiles.init();

    super.initState();

    Timer.run(() => showTemplateDialog(cancellable: false));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Document>.value(value: doc),
        ChangeNotifierProvider<Selection>.value(value: selection),
        ChangeNotifierProvider<EditorState>.value(value: editorState),
        ChangeNotifierProvider<RecentFiles>.value(value: recentFiles),
      ],
      child: Stack(
        children: [
          Positioned(
            top: EditorDimensions.toolbarHeight + EditorDimensions.rulerWidth,
            left: EditorDimensions.objectLibraryPanelWidth + EditorDimensions.rulerWidth,
            right: EditorDimensions.propertyInspectorPanelWidth,
            bottom: 0,
            child: DesignEditor(),
          ),
          Positioned(
            top: EditorDimensions.toolbarHeight + EditorDimensions.rulerWidth,
            left: EditorDimensions.objectLibraryPanelWidth,
            bottom: 0,
            width: EditorDimensions.rulerWidth,
            child: Ruler(RulerDirection.vertical),
          ),
          Positioned(
            top: EditorDimensions.toolbarHeight,
            left: EditorDimensions.objectLibraryPanelWidth + EditorDimensions.rulerWidth,
            right: EditorDimensions.propertyInspectorPanelWidth,
            height: EditorDimensions.rulerWidth,
            child: Ruler(RulerDirection.horizontal),
          ),
          Positioned(
            top: EditorDimensions.toolbarHeight,
            left: EditorDimensions.objectLibraryPanelWidth,
            width: EditorDimensions.rulerWidth,
            height: EditorDimensions.rulerWidth,
            child: RulerControl(),
          ),
          Positioned(
            top: EditorDimensions.toolbarHeight,
            left: 0,
            bottom: 0,
            width: EditorDimensions.objectLibraryPanelWidth,
            child: ObjectLibrary(),
          ),
          Positioned(
            top: EditorDimensions.toolbarHeight,
            bottom: 0,
            right: 0,
            width: EditorDimensions.propertyInspectorPanelWidth,
            child: PropertyInspector(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            // Toolbar actual size to occupy full screen for main menu
            height: MediaQuery.of(context).size.height,
            child: Toolbar(
              onNewDocument: newDocument,
              onNewDocumentFromTemplate: newDocumentFromTemplate,
              onOpenDocument: openDocument,
              onOpenDocumentHandle: openDocumentHandle,
              onSaveDocument: saveDocument,
              onSaveDocumentAs: saveDocumentAs,
              onExportAst: exportAst,
            ),
          ),
        ],
      ),
    );
  }
}

/// Graph design core editor.
class DesignEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editorState = Provider.of<EditorState>(context);

    return Stack(
      children: [
        CanvasLayer(), // endless scrolling
        Transform.scale(
          scale: editorState.zoomScale,
          alignment: Alignment.topLeft,
          child: Stack(
            children: [
              EdgesLayer(),
              NodesLayer(),
            ],
          ),
        ),

        /// Pointer layer doesn't scale with edges/nodes to make sure even when
        /// drawing area is smaller than canvas background events outside that
        /// area are still handled.
        PointerLayer(),
      ],
    );
  }
}
