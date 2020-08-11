import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../config.dart';

class HttpClient extends http.BaseClient {
  final Map<String, String> defaultHeaders;
  final http.Client _httpClient = http.Client();

  HttpClient({this.defaultHeaders = const {}});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }

  @override
  Future<Response> get(url, {Map<String, String> headers}) {
    headers.addAll(defaultHeaders);
    return _httpClient.get(url, headers: headers);
  }

  @override
  Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) {
    headers.addAll(defaultHeaders);
    return _httpClient.post(url, headers: headers, encoding: encoding);
  }

  @override
  Future<Response> patch(url, {Map<String, String> headers, body, Encoding encoding}) {
    headers.addAll(defaultHeaders);
    return _httpClient.patch(url, headers: headers, encoding: encoding);
  }

  @override
  Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding}) {
    headers.addAll(defaultHeaders);
    return _httpClient.put(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<Response> head(url, {Map<String, String> headers}) {
    headers.addAll(defaultHeaders);
    return _httpClient.head(url, headers: headers);
  }

  @override
  Future<Response> delete(url, {Map<String, String> headers}) {
    headers.addAll(defaultHeaders);
    return _httpClient.delete(url, headers: headers);
  }
}

class GoogleAuthManager {
  static String get _clientId => config['googleClientId'];

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      DriveApi.DriveFileScope,
    ],
    clientId: _clientId,
  );

  static Future<GoogleSignInAccount> signIn() async {
    try {
      return _googleSignIn.signIn();
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<GoogleSignInAccount> signInSilently() async => _googleSignIn.signInSilently();

  static Future<void> signOut() async {
    try {
      return _googleSignIn.disconnect();
    } catch (error) {
      print(error);
    }
  }
}
