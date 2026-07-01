import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> sendAnnouncementEmail({
 required String title; 
 required String content; 
 required String category; 
 required String recipienEmai; 
 required String authorRole,
  required List<String> targetGrades,
  required bool apOnly, 

  
}); 