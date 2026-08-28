import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/profile/data/services/profile_services.dart';
import 'package:amlystuhub/features/profile/domain/models/profile_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileServiceProvider = Provider<ProfileService>(
  (ref) => ProfileService(),
);

final userProfileRequestsProvider = StreamProvider<List<ProfileRequestModel>>((
  ref,
) {
  final user = ref.watch(currentUserModelProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(profileServiceProvider).watchUserRequests(user.uid);
});

final adminPendingRequestsProvider = StreamProvider<List<ProfileRequestModel>>((
  ref,
) {
  return ref.watch(profileServiceProvider).watchPendingAdminRequests();
});

class ProfileController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> updateName(String newName) async {
    final user = ref.read(currentUserModelProvider).value;
    if (user == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(profileServiceProvider)
          .updateName(user.uid, newName.trim());
    });

    return !state.hasError;
  }

  Future<bool> updatePassword(String newPassword) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(profileServiceProvider).updatePassword(newPassword.trim());
    });

    return !state.hasError;
  }

  Future<bool> requestAcademicDetailsChange({
    required int newGradeLevel,
    required bool newIsApStudent,
  }) async {
    final user = ref.read(currentUserModelProvider).value;
    if (user == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(profileServiceProvider)
          .submitProfileChangeRequest(
            uid: user.uid,
            studentName: user.name,
            studentEmail: user.email,
            currentGrade: user.gradeLevel,
            currentAp: user.isApStudent,
            requestedGrade: newGradeLevel,
            requestedAp: newIsApStudent,
          );
    });

    return !state.hasError;
  }

  Future<bool> resolveAdminRequest(
    ProfileRequestModel request,
    bool approve,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(profileServiceProvider).processRequest(request, approve);
    });

    return !state.hasError;
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, void>(ProfileController.new);
