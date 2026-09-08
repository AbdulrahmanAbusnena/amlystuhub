import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class EmailRemoteDataSources {
  final FirebaseAuth _auth;
  final http.Client _httpClient;
  final String _makeWebhookUrl;

  EmailRemoteDataSources({
    required FirebaseAuth auth,
    required http.Client httpClient,
    required String makeWebhookUrl,
  }) : _auth = auth,
       _httpClient = httpClient,
       _makeWebhookUrl = makeWebhookUrl;

  Future<void> sendBroaCast({
    required String title,
    required String content,
    required String category,
    String? surveyUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Failed to retrive authentication token');
    }

    final idToken = await user.getIdToken();
    if (idToken == null) {
      throw Exception('Failed to retrieve authentication token.');
    }

    final response = await _httpClient.post(
      Uri.parse(_makeWebhookUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': category,
        'surveyUrl': surveyUrl,
        'authorUid': user.uid,
        'authorEmail': user.email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to trigger email broadcast: ${response.statusCode}',
      );
    }
  }
}
