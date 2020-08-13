import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'web.dart' if (dart.library.io) 'desktop.dart' as fs;

bool isFileSystemAvailable() => fs.isFileSystemAvailable();

// const _configUrl = 'chrome://flags/#native-file-system-api';
const _descriptionUrl = 'https://web.dev/native-file-system/';

void _launchUrl(String url) async {
  await launch(url);
}

void showNativeFileSystemGuide(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enable Native File System API'),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: 600,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    'If you are using Edge or Chrome browser, you can enable the experimental Native File System API to access your local file system.'),
                Text('To enable Native File System API:'),
                Text('* Open chrome://flags'),
                Text('* Find Native File System API and enable it'),
                Text('* Restart your borwser'),
                RaisedButton(
                  child: Text('Click here to learn more about Native File System API'),
                  onPressed: () {
                    _launchUrl(_descriptionUrl);
                  },
                ),
              ],
            ),
          );
        }),
        actions: <Widget>[
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
}
