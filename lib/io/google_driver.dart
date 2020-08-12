import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GoogleDrive {
  GoogleDrive(this._account);
  final GoogleSignInAccount _account;

  static const String _appName = kReleaseMode ? 'mandrake' : 'mandrake-dev';

  Future<FilesResourceApi> get _api async {
    final client = HttpClient(await _account.authHeaders);
    return DriveApi(client).files;
  }

  Future<FileList> listFiles() async {
    // TODO: pagination?
    return (await _api).list(q: "appProperties has {key='app' and value='$_appName'}");
  }

  Future<File> uploadFile(String name, String content) async {
    final file = File();
    file.name = name;
    if (!name.endsWith('.json')) {
      file.name += '.json';
    }
    file.appProperties = {'app': _appName};

    final bytes = utf8.encode(content);
    final stream = Stream.fromIterable([bytes]);
    final media = Media(stream, bytes.length, contentType: 'application/json');

    return (await _api).create(file, uploadMedia: media);
  }
}

class HttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _httpClient = http.Client();

  HttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _httpClient.send(request);
  }

  @override
  Future<Response> get(url, {Map<String, String> headers}) {
    headers.addAll(_headers);
    return _httpClient.get(url, headers: headers);
  }

  @override
  Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) {
    headers.addAll(_headers);
    return _httpClient.post(url, headers: headers, encoding: encoding);
  }

  @override
  Future<Response> patch(url, {Map<String, String> headers, body, Encoding encoding}) {
    headers.addAll(_headers);
    return _httpClient.patch(url, headers: headers, encoding: encoding);
  }

  @override
  Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding}) {
    headers.addAll(_headers);
    return _httpClient.put(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<Response> head(url, {Map<String, String> headers}) {
    headers.addAll(_headers);
    return _httpClient.head(url, headers: headers);
  }

  @override
  Future<Response> delete(url, {Map<String, String> headers}) {
    headers.addAll(_headers);
    return _httpClient.delete(url, headers: headers);
  }
}
