import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/screens/course_screen.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_providers.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/add_course.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcademicHubScreen extends ConsumerWidget {
  const AcademicHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesStreamProvider);
    final userAsync = ref.watch(currentUserModelProvider);

    final isLeadership = userAsync.value?.role.canPublishAnnouncements ?? false;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 900 ? 32.0 : 20.0;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          32,
                          horizontalPadding,
                          12,
                        ),
                        child: _AcademicHeader(isLeadership: isLeadership),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: const _SectionHeading(title: 'Courses'),
                      ),
                    ),
                  ),
                ),

                coursesAsync.when(
                  loading: () => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: _ErrorState(
                        message: 'Unable to load courses.',
                        details: '$error',
                      ),
                    ),
                  ),
                  data: (courses) {
                    if (courses.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: _EmptyCoursesState(isLeadership: isLeadership),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        12,
                        horizontalPadding,
                        40,
                      ),
                      sliver: SliverLayoutBuilder(
                        builder: (context, sliverConstraints) {
                          final width = sliverConstraints.crossAxisExtent;

                          final columns = width >= 1000
                              ? 3
                              : width >= 680
                              ? 2
                              : 1;

                          return SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: columns == 1
                                      ? 3.8
                                      : columns == 2
                                      ? 2.25
                                      : 2.15,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final course = courses[index];

                              return _CourseDirectoryItem(course: course);
                            }, childCount: courses.length),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PAGE HEADER
// -----------------------------------------------------------------------------

class _AcademicHeader extends StatelessWidget {
  final bool isLeadership;

  const _AcademicHeader({required this.isLeadership});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Academic Hub',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  'Course materials, study guides, exam preparation, '
                  'and academic resources.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLeadership) ...[
          const SizedBox(width: 24),
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddCourseDialog(),
              );
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add course'),
          ),
        ],
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// SECTION HEADING
// -----------------------------------------------------------------------------

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Divider(color: colorScheme.outlineVariant)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COURSE DIRECTORY ITEM
// -----------------------------------------------------------------------------

class _CourseDirectoryItem extends StatefulWidget {
  final CourseModel course;

  const _CourseDirectoryItem({required this.course});

  @override
  State<_CourseDirectoryItem> createState() => _CourseDirectoryItemState();
}

class _CourseDirectoryItemState extends State<_CourseDirectoryItem> {
  bool _hovering = false;

  void _openCourse() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(course: widget.course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final course = widget.course;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _hovering
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovering ? colorScheme.outline : colorScheme.outlineVariant,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _openCourse,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _courseMeta(course),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (course.description.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          course.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _courseMeta(CourseModel course) {
    final parts = <String>[];

    if (course.code.trim().isNotEmpty) {
      parts.add(course.code.trim());
    }

    if (course.category.trim().isNotEmpty) {
      parts.add(course.category.trim());
    }

    return parts.join(' · ');
  }
}

// -----------------------------------------------------------------------------
// EMPTY STATE
// -----------------------------------------------------------------------------

class _EmptyCoursesState extends StatelessWidget {
  final bool isLeadership;

  const _EmptyCoursesState({required this.isLeadership});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 560),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_outlined,
            size: 32,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No courses yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLeadership
                ? 'Add the first academic course to begin building the hub.'
                : 'Academic courses will appear here once they are added.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ERROR STATE
// -----------------------------------------------------------------------------

class _ErrorState extends StatelessWidget {
  final String message;
  final String details;

  const _ErrorState({required this.message, required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 32),
          const SizedBox(height: 12),
          Text(message, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              details,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
