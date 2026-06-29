import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/announcement_model.dart';
import 'announcement_state.dart';
import 'package:amlystuhub/features/auth/domain/models/user_model.dart';
import '../../data/announcement_services.dart';

class AnnouncementController extends StateNotifier<AnnouncementState> {
  late final AnnouncementServices _service;
}
