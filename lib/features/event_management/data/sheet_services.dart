import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gsheets/gsheets.dart';

class SheetService {
  static final String _credentials = jsonEncode({
    "type": "service_account",
    "project_id": "amlystuhub",
    "private_key_id": dotenv.env['PRIVATE_KEY_ID'] ?? '',
    "private_key": (dotenv.env['PRIVATE_KEY'] ?? '').replaceAll(r'\n', '\n'),
    "client_email": dotenv.env['CLIENT_EMAIL'] ?? '',
    "client_id": dotenv.env['CLIENT_ID'] ?? '',
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/${dotenv.env['CLIENT_EMAIL'] ?? ''}",
    "universe_domain": "googleapis.com",
  });

  static final String _spreadsheetId = dotenv.env['SPREADSHEET_ID'] ?? '';

  Future<List<List<String>>> fetchAcceptingDelegates() async {
    try {
      final gsheets = GSheets(_credentials);

      final spreadsheet = await gsheets.spreadsheet(_spreadsheetId);

      final sheet = spreadsheet.worksheetByTitle('Responses');

      if (sheet == null) {
        throw Exception(
          'Could not find the "Responses" worksheet in the spreadsheet.',
        );
        return [];
      }

      final List<List<String>> rows = await sheet.values.allRows(fromRow: 2);

      return rows;

      // skipping row 1
    } catch (e) {
      print('Error fetching response forms data: $e');
      return [];
    }
  }
}
