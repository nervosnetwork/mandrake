import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandrake/models/command.dart';
import 'package:provider/provider.dart';
import 'package:truncate/truncate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/document.dart';
import '../models/document_template.dart';
import '../models/selection.dart';
import '../models/editor_state.dart';
import '../models/recent_files.dart';
import '../models/undo_manager.dart';

import '../io/io.dart';
import '../io/file_chooser.dart';
import '../io/doc_reader.dart';
import '../io/doc_writer.dart';
import '../io/gist_doc_reader.dart';
import '../io/gist_doc_writer.dart';
import '../io/ast_writer.dart';

import 'toolbar.dart';
import 'object_library.dart';
import 'property_inspector.dart';
import 'ruler.dart';
import 'message_box.dart';

import '../views/editor/editor_dimensions.dart';
import '../views/editor/canvas_layer.dart';
import '../views/editor/edges_layer.dart';
import '../views/editor/nodes_layer.dart';
import '../views/editor/pointer_layer.dart';

class Editor extends StatefulWidget {
  final String gistUrl; // Open remote gist

  Editor({this.gistUrl});

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
    selection = Selection(doc);
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
      showTemplateDialog(recentFiles: recentFiles);
    });
  }

  Future<void> showTemplateDialog({
    @required RecentFiles recentFiles,
    bool cancellable = true,
  }) async {
    final result = await showDialog<_TemplateDialogResult>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var selectedTemplate = DocumentTemplate.templates.first;

        return AlertDialog(
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: 650,
              height: isFileSystemAvailable() ? 550 : 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose a template', style: Theme.of(context).textTheme.headline5),
                  ...DocumentTemplate.templates.map((template) {
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
                  SizedBox(height: 20),
                  if (isFileSystemAvailable()) ...[
                    Text('Recent files', style: Theme.of(context).textTheme.headline6),
                    ...recentFiles
                        .files()
                        .sublist(0, min(5, recentFiles.files().length))
                        .map((file) {
                      return FlatButton(
                        onPressed: () {
                          Navigator.pop(context, _TemplateDialogResult(fileHandle: file));
                        },
                        child: Text(truncate(file.name, 80, position: TruncatePosition.middle)),
                      );
                    }).toList(),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (cancellable)
                        RaisedButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context, _TemplateDialogResult());
                          },
                        ),
                      SizedBox(width: 20),
                      RaisedButton(
                        child: Text('Create'),
                        onPressed: () {
                          Navigator.pop(context, _TemplateDialogResult(template: selectedTemplate));
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
          actions: [],
        );
      },
    );

    if (result.fileHandle != null) {
      readDocumentHandle(result.fileHandle);
    } else if (result.template != null) {
      setState(() {
        doc = result.template.create();
        docHandle = null;
        resetState();
      });
    }
  }

  void openDocument() {
    promptToSaveIfNecessary(() async {
      FileHandle handle;
      if (isFileSystemAvailable()) {
        handle = await showOpenPanel(
          allowedFileTypes: [
            FileFilterGroup(extensions: ['json'], label: 'JSON')
          ],
        );

        if (handle == null) {
          return;
        }
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

  Future<void> promptToRestoreIfNecessary() async {
    final lastEditingDoc = await readLastEditingDoc();
    if (lastEditingDoc == null) {
      return;
    }

    final lastSnapshotTime = (await lastSnapshotingDocTime).toString().split('.').first;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: 400,
              height: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Restore last session', style: Theme.of(context).textTheme.headline5),
                  Text(
                    'Some unsaved data was found in the cache. Restore your unsaved data if you want to continue editing it.',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    '${lastEditingDoc.fileName} ($lastSnapshotTime)',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            );
          }),
          actions: [
            FlatButton(
              child: Text('Do not restore'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            SizedBox(width: 20),
            FlatButton(
              child: Text('Restore'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    if (result) {
      setState(() {
        doc = lastEditingDoc;
        doc.rebuild();
        resetState();
      });
    } else {
      deleteDocFromLocalStorage();
    }
  }

  void readDocumentHandle(FileHandle handle) async {
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
    } else {
      setState(() {
        doc = DocumentTemplate(DocumentTemplateType.blank).create();
        docHandle = null;
        resetState();
        showReadError();
      });
    }
  }

  void openDocumentHandle(FileHandle handle) {
    promptToSaveIfNecessary(() async {
      readDocumentHandle(handle);
    });
  }

  void showReadError() {
    showMessageBox(
      context,
      'Failed to read file',
      'Cannot open the file. A blank document was created instead.',
    );
  }

  static final gistTokenKey = 'gist-token';
  Future<String> readGistToken() {
    return readFromLocalStorage(gistTokenKey);
  }

  void persistGistToken(String token) async {
    writeToLocalStorage(gistTokenKey, token);
  }

  void shareGist() async {
    final token = await readGistToken() ?? '';
    final result = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final fileNameController = TextEditingController(text: doc.fileName);
        final tokenController = TextEditingController(text: token);
        var persistToken = token.isNotEmpty;

        return AlertDialog(
          title: Text('Share with GitHub gists'),
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: 500,
              height: 380,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('File name:'),
                  TextField(
                    controller: fileNameController,
                  ),
                  SizedBox(height: 20),
                  Text('GitHub personal access token:'),
                  TextField(
                    controller: tokenController,
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'We highly recommend that you create a personal access token with only the "gist" scope.',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: Text('Persist personal access token in local storage'),
                    value: persistToken,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.all(0),
                    onChanged: (value) => {
                      setState(() {
                        persistToken = value;
                      })
                    },
                  ),
                  Text(
                    'IMPORTANT: saving the token in local storage is NOT secure. Please use this option at your own risk.',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RaisedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        child: Text('Share'),
                        onPressed: () {
                          Navigator.pop(context, [
                            fileNameController.text,
                            tokenController.text,
                            persistToken.toString(),
                          ]);
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        );
      },
    );

    if (result == null) {
      return;
    }

    try {
      final gist = await GistDocWriter(doc, result[0], result[1]).write();
      final mandrakeUrl = 'https://nervosnetwork.github.io/mandrake/#/gist/${gist.id}';
      if (gist == null) {
        throw 'Creating gist failed. Please check that the personal access token is correct';
      }

      if (result[2] == true.toString()) {
        persistGistToken(result[1]);
      } else {
        persistGistToken(null);
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final mandrakeUrlController = TextEditingController(text: mandrakeUrl);
          final gistUrlController = TextEditingController(text: gist.url);
          gistUrlController.selection = TextSelection(baseOffset: 0, extentOffset: gist.url.length);

          return AlertDialog(
            title: Text('Shared to gists.'),
            content: Container(
              width: 680,
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your gist URL is:'),
                  TextField(
                    controller: gistUrlController,
                    readOnly: true,
                    autofocus: true,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      RaisedButton(
                        child: Text('Copy gist URL'),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: gist.url));
                        },
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        child: Text('View gist'),
                        onPressed: () {
                          launch(gist.url);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text('Mandrake quick URL is:'),
                  TextField(
                    controller: mandrakeUrlController,
                    readOnly: true,
                    autofocus: true,
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RaisedButton(
                        child: Text('Copy mandrake URL'),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: mandrakeUrl));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context, null);
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showMessageBox(context, 'Sharing to gists failed.', e.toString());
    }
  }

  void openGist() {
    promptToSaveIfNecessary(() async {
      final url = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: Text('Enter a gist URL or id:'),
            content: Container(
              width: 500,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Note: only the first file will be parsed.'),
                  TextField(
                    controller: controller,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RaisedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        child: Text('Open'),
                        onPressed: () {
                          Navigator.pop(context, controller.text);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );

      if (url == null) {
        return;
      }
      readGist(url);
    });
  }

  void readGist(String url) async {
    final docRead = await GistDocReader(url).read();
    if (docRead != null) {
      setState(() {
        doc = docRead;
        doc.rebuild();
        doc.markNotDirty();
        docHandle = null;
        resetState();
      });
    } else {
      setState(() {
        doc = DocumentTemplate(DocumentTemplateType.blank).create();
        docHandle = null;
        resetState();
        showReadError();
      });
    }
  }

  Future<bool> saveDocument() async {
    if (isFileSystemAvailable()) {
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
        recordSavingDocTime();
        doc.markNotDirty();
        return true;
      }
      return false;
    } else {
      await DocWriter(doc, FileHandle(null, name: doc.fileName)).write();
      recordSavingDocTime();
      doc.markNotDirty();
      return true;
    }
  }

  // Web without Native File System API should never call this.
  Future<bool> saveDocumentAs() async {
    assert(isFileSystemAvailable());

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
      recordSavingDocTime();
      doc.markNotDirty();
      return true;
    }
    return false;
  }

  void exportAst() async {
    if (isFileSystemAvailable()) {
      final handle = await showSavePanel(
        suggestedFileName: 'ast.bin',
      );

      if (handle != null) {
        await AstWriter(doc, handle).write();
      }
    } else {
      await AstWriter(doc, FileHandle(null, name: 'ast.bin')).write();
    }
  }

  void trackRecentFile(FileHandle fileHandle) async {
    if (!isFileSystemAvailable()) {
      return;
    }
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
                Text("There're unsaved changes. Do you want to save the current document?"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes, save.'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text('No, discard.'),
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

  static final lastEditingDocKey = 'last-editing-doc';
  static final lastSavingDocTimeKey = 'last-saving-doc-time';
  static final lastEditingDocSnapshotTimeKey = 'last-editing-doc-snapshot-time';

  void recordSavingDocTime() async {
    writeToLocalStorage(lastSavingDocTimeKey, DateTime.now().toIso8601String());
  }

  Future<DateTime> get lastSavingDocTime async {
    final content = await readFromLocalStorage(lastSavingDocTimeKey);
    try {
      return DateTime.parse(content);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  void recordSnapshotingDocTime() async {
    writeToLocalStorage(lastEditingDocSnapshotTimeKey, DateTime.now().toIso8601String());
  }

  Future<DateTime> get lastSnapshotingDocTime async {
    final content = await readFromLocalStorage(lastEditingDocSnapshotTimeKey);
    try {
      return DateTime.parse(content);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  void persistDocToLocalStorage() async {
    if (doc != null && !doc.isDirty) {
      return;
    }

    final content = jsonEncode(doc);
    writeToLocalStorage(lastEditingDocKey, content);
    recordSnapshotingDocTime();
  }

  void deleteDocFromLocalStorage() async {
    writeToLocalStorage(lastEditingDocKey, null);
  }

  Future<Document> readLastEditingDoc() async {
    final lastSnapshotTime = await lastSnapshotingDocTime;
    final lastSaveTime = await lastSavingDocTime;
    if (lastSnapshotTime.difference(lastSaveTime).inSeconds > 10) {
      final content = await readFromLocalStorage(lastEditingDocKey);
      try {
        return Document.fromJson(jsonDecode(content));
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  @override
  void initState() {
    doc = DocumentTemplate(DocumentTemplateType.blank).create();
    docHandle = null;
    resetState();

    recentFiles = RecentFiles();
    recentFiles.init();

    super.initState();

    Timer.run(() {
      if (widget.gistUrl != null) {
        readGist(widget.gistUrl);
      } else {
        promptToRestoreIfNecessary();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Document>.value(value: doc),
        ChangeNotifierProvider<Selection>.value(value: selection),
        ChangeNotifierProvider<EditorState>.value(value: editorState),
        ChangeNotifierProvider<RecentFiles>.value(value: recentFiles),
        ChangeNotifierProvider<CommandState>.value(value: CommandState.shared()),
      ],
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Consumer<CommandState>(builder: (context, doc, child) {
              persistDocToLocalStorage();
              return Text('');
            }),
          ),
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
              onOpenGist: openGist,
              onShareGist: shareGist,
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

class _TemplateDialogResult {
  _TemplateDialogResult({this.fileHandle, this.template});

  FileHandle fileHandle;
  DocumentTemplate template;
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
