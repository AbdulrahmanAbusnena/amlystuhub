import 'package:amlystuhub/features/advocacy/domain/models/advocacy_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvocacyServices {
  final FirebaseFirestore _firestore;

  AdvocacyServices(this._firestore);

  // Tickets

  Stream<List<TicketModel>> watchUserTickets(String userId) {
    return _firestore
        .collection('tickets')
        .where('authorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs
              .map((doc) => TicketModel.fromJson(doc.data(), doc.id))
              .toList();
          docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return docs;
        });
  }

  Stream<List<TicketModel>> watchAllTickets() {
    return _firestore.collection('tickets').snapshots().map((snapshot) {
      final docs = snapshot.docs
          .map((doc) => TicketModel.fromJson(doc.data(), doc.id))
          .toList();
      docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return docs;
    });
  }

  Future<void> submitTicket(TicketModel ticket) async {
    await _firestore.collection('tickets').add(ticket.toJson());
  }

  Future<void> updateTicket(TicketModel ticket) async {
    await _firestore
        .collection('tickets')
        .doc(ticket.id)
        .update(ticket.toJson());
  }

  Future<void> updateTicketStatus(
    String ticketId,
    TicketStatus status,
    String? note,
  ) async {
    await _firestore.collection('tickets').doc(ticketId).update({
      'status': status.name,
      if (note != null) 'internalNote': note,
    });
  }

  Future<void> deleteTicket(String ticketId) async {
    await _firestore.collection('tickets').doc(ticketId).delete();
  }

  // Surveys

  Stream<List<SurveyModel>> watchActiveSurveys() {
    return _firestore
        .collection('surveys')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs
              .map((doc) => SurveyModel.fromJson(doc.data(), doc.id))
              .toList();
          docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return docs;
        });
  }

  Stream<List<SurveyModel>> watchAllSurveys() {
    return _firestore.collection('surveys').snapshots().map((snapshot) {
      final docs = snapshot.docs
          .map((doc) => SurveyModel.fromJson(doc.data(), doc.id))
          .toList();
      docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return docs;
    });
  }

  Future<void> createSurvey(SurveyModel survey) async {
    await _firestore.collection('surveys').add(survey.toJson());
  }

  Future<void> updateSurvey(SurveyModel survey) async {
    await _firestore
        .collection('surveys')
        .doc(survey.id)
        .update(survey.toJson());
  }

  Future<void> toggleSurveyStatus(String surveyId, bool isActive) async {
    await _firestore.collection('surveys').doc(surveyId).update({
      'isActive': isActive,
    });
  }

  Future<void> deleteSurvey(String surveyId) async {
    await _firestore.collection('surveys').doc(surveyId).delete();
  }
}
