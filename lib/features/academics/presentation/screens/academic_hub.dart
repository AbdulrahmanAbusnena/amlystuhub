import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/dialog/academic_dialogs.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/subject_detail_screen.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/subject_card.dart';

class AcademicHubScreen extends ConsumerStatefulWidget {
  const AcademicHubScreen({super.key});

  @override
  ConsumerState<AcademicHubScreen> createState() => _AcademicHubScreenState();
}

class _AcademicHubScreenState extends ConsumerState<AcademicHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final program = _tabController.index == 0
            ? ProgramType.ap
            : ProgramType.generalHS;
        ref
            .read(academicControllerProvider.notifier)
            .setSelectedProgram(program);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically check user role (identical to Announcements implementation)
    final userRoleAsync = ref.watch(currentUserModelProvider);
    final isStuCoAdmin = userRoleAsync.maybeWhen(
      data: (role) => role == 'StuCoAdmin' || role == 'Admin',
      orElse: () => false,
    );

    final state = ref.watch(academicControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Academic Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'AP Program'),
            Tab(text: 'General High School'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref
                    .read(academicControllerProvider.notifier)
                    .setSearchQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Search subjects or courses...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(academicControllerProvider.notifier)
                              .setSearchQuery('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSubjectsTab(
                  context,
                  ref,
                  streamProvider: apSubjectsStreamProvider,
                  isApTab: true,
                  searchQuery: state.searchQuery,
                  isStuCoAdmin: isStuCoAdmin,
                ),
                _buildSubjectsTab(
                  context,
                  ref,
                  streamProvider: generalHsSubjectsStreamProvider,
                  isApTab: false,
                  searchQuery: state.searchQuery,
                  isStuCoAdmin: isStuCoAdmin,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isStuCoAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _openAddSubjectDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Subject'),
            )
          : null,
    );
  }

  Widget _buildSubjectsTab(
    BuildContext context,
    WidgetRef ref, {
    required StreamProvider<List<AcademicSubjectModel>> streamProvider,
    required bool isApTab,
    required String searchQuery,
    required bool isStuCoAdmin,
  }) {
    final subjectsAsync = ref.watch(streamProvider);

    return subjectsAsync.when(
      data: (subjects) {
        final filteredSubjects = subjects.where((s) {
          final query = searchQuery.toLowerCase();
          return s.title.toLowerCase().contains(query) ||
              s.code.toLowerCase().contains(query) ||
              s.category.toLowerCase().contains(query);
        }).toList();

        return CustomScrollView(
          slivers: [
            if (isApTab && searchQuery.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: _buildGeneralApBanner(context),
                ),
              ),
            if (filteredSubjects.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No subjects found',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final subject = filteredSubjects[index];
                    return SubjectCard(
                      subject: subject,
                      isStuCoAdmin: isStuCoAdmin,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SubjectDetailScreen(subject: subject),
                          ),
                        );
                      },
                      onEdit: () =>
                          _openEditSubjectDialog(context, ref, subject),
                      onDelete: () =>
                          _confirmDeleteSubject(context, ref, subject),
                    );
                  }, childCount: filteredSubjects.length),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading subjects: $err')),
    );
  }

  Widget _buildGeneralApBanner(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Open General AP Guide Resources View
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'GLOBAL GUIDE',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward, color: colorScheme.onPrimary),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'General AP Master Guide',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Access universal AP exam strategies, global drive links, and College Board playlists.',
                  style: TextStyle(
                    color: colorScheme.onPrimary.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openAddSubjectDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AcademicSubjectDialog(
        currentProgram: _tabController.index == 0
            ? ProgramType.ap
            : ProgramType.generalHS,
        onSave: (subject) async {
          await ref
              .read(academicControllerProvider.notifier)
              .addSubject(subject);
        },
      ),
    );
  }

  void _openEditSubjectDialog(
    BuildContext context,
    WidgetRef ref,
    AcademicSubjectModel subject,
  ) {
    showDialog(
      context: context,
      builder: (_) => AcademicSubjectDialog(
        subject: subject,
        currentProgram: subject.programType,
        onSave: (updated) async {
          await ref
              .read(academicControllerProvider.notifier)
              .updateSubject(subject.id, updated);
        },
      ),
    );
  }

  void _confirmDeleteSubject(
    BuildContext context,
    WidgetRef ref,
    AcademicSubjectModel subject,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text(
          'Are you sure you want to delete ${subject.title}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(academicControllerProvider.notifier)
                  .deleteSubject(subject.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
