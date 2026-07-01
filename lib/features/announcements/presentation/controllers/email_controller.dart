import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> broadcastAnnouncementEmails({
  required String title,
  required String content,
  required String category,
  required String authorName,
  required String authorRole,
  required List<String> targetGrades,
  required bool apOnly,
}) async {
  // 1. Live target query fetch directly from your users collection
  Query usersQuery = FirebaseFirestore.instance.collection('users');

  if (targetGrades.isNotEmpty) {
    usersQuery = usersQuery.where('gradeLevel', whereIn: targetGrades);
  }

  if (apOnly) {
    usersQuery = usersQuery.where('isApStudent', isEqualTo: true);
  }

  try {
    QuerySnapshot snapshot = await usersQuery.get();
    List<String> recipientEmails = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['email'] != null) {
        recipientEmails.add(data['email'] as String);
      }
    }

    if (recipientEmails.isEmpty) {
      print("No matching student emails found for this target criteria.");
      return;
    }

    // 2. Blast the network payload to EmailJS
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Origin': 'http://localhost', // Required by EmailJS security validators
      },
      body: json.encode({
        'service_id': 'YOUR_EMAILJS_SERVICE_ID', // 🔑 Paste your Service ID
        'template_id': 'YOUR_EMAILJS_TEMPLATE_ID', // 🔑 Paste your Template ID
        'user_id': 'YOUR_EMAILJS_PUBLIC_KEY', // 🔑 Paste your Public Key
        'template_params': {
          'title': title,
          'content': content,
          'category': category.toUpperCase(),
          'authorName': authorName,
          'authorRole': authorRole,
          'bcc_list': recipientEmails.join(
            ',',
          ), // Converted to comma-separated string
        },
      }),
    );

    if (response.statusCode == 200) {
      print(
        "StuCo Hub: Email broadcast successfully sent via EmailJS pipeline!",
      );
    } else {
      print("EmailJS Broadcast Error: ${response.body}");
    }
  } catch (e) {
    print("Error executing student network query: $e");
  }
}
