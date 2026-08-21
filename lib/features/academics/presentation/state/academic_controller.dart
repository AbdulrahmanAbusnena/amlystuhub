// Service Provider
import 'package:amlystuhub/features/academics/data/services/academic_services.dart';
import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final academicServiceProvider = Provider<AcademicRemoteService>((ref) {
  return AcademicRemoteService();
});

final apSubjectsStreamProvider = StreamProvider<List<AcademicSubjectModel>>((
  ref,
) {
  return ref
      .watch(academicServiceProvider)
      .getSubjectsByProgram(ProgramType.ap);
});

final generalHsSubjectsStreamProvider =
    StreamProvider<List<AcademicSubjectModel>>((ref) {
      return ref
          .watch(academicServiceProvider)
          .getSubjectsByProgram(ProgramType.generalHS);
    });

final generalApResourcesStreamProvider =
    StreamProvider<List<AcademicResourceModel>>((ref) {
      return ref.watch(academicServiceProvider).getGeneralApResources();
    });

final subjectResourcesStreamProvider =
    StreamProvider.family<List<AcademicResourceModel>, String>((
      ref,
      subjectId,
    ) {
      return ref.watch(academicServiceProvider).getSubjectResources(subjectId);
    });

class AcademicController extends StateNotifier<AcademicState> {
  final AcademicRemoteService _service;

  AcademicController(this._service) : super(const AcademicState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedProgram(ProgramType program) {
    state = state.copyWith(selectedProgram: program);
  }

  void setCategoryFilter(ResourceCategory? category) {
    state = state.copyWith(selectedCategoryFilter: category);
  }

  Future<bool> addSubject(AcademicSubjectModel subject) async {
    state = state.copyWith(operationStatus: const AsyncValue.loading());
    try {
      await _service.addSubject(subject);
      state = state.copyWith(operationStatus: const AsyncValue.data(null));
      return true;
    } catch (e, st) {
      state = state.copyWith(operationStatus: AsyncValue.error(e, st));
      return false;
    }
  }

  Future<bool> updateSubject(
    String subjectId,
    AcademicSubjectModel subject,
  ) async {
    state = state.copyWith(operationStatus: const AsyncValue.loading());
    try {
      await _service.updateSubject(subjectId, subject);
      state = state.copyWith(operationStatus: const AsyncValue.data(null));
      return true;
    } catch (e, st) {
      state = state.copyWith(operationStatus: AsyncValue.error(e, st));
      return false;
    }
  }

  Future<bool> deleteSubject(String subjectId) async {
    state = state.copyWith(operationStatus: const AsyncValue.loading());
    try {
      await _service.deleteSubject(subjectId);
      state = state.copyWith(operationStatus: const AsyncValue.data(null));
      return true;
    } catch (e, st) {
      state = state.copyWith(operationStatus: AsyncValue.error(e, st));
      return false;
    }
  }

  Future<bool> addResource(AcademicResourceModel resource) async {
    state = state.copyWith(operationStatus: const AsyncValue.loading());
    try {
      await _service.addResource(resource);
      state = state.copyWith(operationStatus: const AsyncValue.data(null));
      return true;
    } catch (e, st) {
      state = state.copyWith(operationStatus: AsyncValue.error(e, st));
      return false;
    }
  }

  Future<bool> updateResource(
    String resourceId,
    AcademicResourceModel resource,
  ) async {
    state = state.copyWith(operationStatus: const AsyncValue.loading());
    try {
      await _service.updateResource(resourceId, resource);
      state = state.copyWith(operationStatus: const AsyncValue.data(null));
      return true;
    } catch (e, st) {
      state = state.copyWith(operationStatus: AsyncValue.error(e, st));
      return false;
    }
  }

  Future<bool> deleteResource(String resourceId) async {
    state = state.copyWith(operationStatus: const AsyncValue.loading());
    try {
      await _service.deleteResource(resourceId);
      state = state.copyWith(operationStatus: const AsyncValue.data(null));
      return true;
    } catch (e, st) {
      state = state.copyWith(operationStatus: AsyncValue.error(e, st));
      return false;
    }
  }
}

final academicControllerProvider =
    StateNotifierProvider<AcademicController, AcademicState>((ref) {
      return AcademicController(ref.watch(academicServiceProvider));
    });
