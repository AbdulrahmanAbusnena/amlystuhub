import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/domain/models/course_model.dart';
import 'package:amlystuhub/features/academics/domain/models/course_section_model.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/dialog/academic_dialogs.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/oritentation_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'resource_item_tile.dart';

class AcademicHubScreen extends ConsumerStatefulWidget {
  const AcademicHubScreen({super.key});

  @override
  ConsumerState<AcademicHubScreen> createState() => _AcademicHubScreenState();
}

class _AcademicHubScreenState extends ConsumerState<AcademicHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openGeneralGuide() async {
    final uri = Uri.parse('https://drive.google.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Academic Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.class_outlined), text: 'AP Courses'),
            Tab(
              icon: Icon(Icons.event_note_outlined),
              text: 'Orientation Schedule',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildApCoursesTab(colorScheme),
          _buildOrientationTab(colorScheme),
        ],
      ),
    );
  }

  Widget _buildApCoursesTab(ColorScheme colorScheme) {
    final academicState = ref.watch(academicControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // General AP Student Guide Card
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_stories,
                        size: 36,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'General AP Student Guide',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Essential strategies and orientation insights for incoming AP students.',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onPrimaryContainer
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _openGeneralGuide,
                        child: const Text('Read Guide'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'AP Course Directory',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              academicState.courses.when(
                data: (courses) {
                  if (courses.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: Text('No courses available.')),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) =>
                        _buildCourseCard(courses[index], colorScheme),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading courses: $err',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(SubjectCourseModel course, ColorScheme colorScheme) {
    final themeColor = Color(course.colorHex);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: themeColor.withValues(alpha: 0.2),
          child: Text(
            course.code.replaceAll('AP ', '').substring(0, 1),
            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          course.description,
          style: const TextStyle(fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Course Sections',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final title = await showDialog<String>(
                          context: context,
                          builder: (_) => const AddSectionDialog(),
                        );
                        if (title != null) {
                          ref
                              .read(academicControllerProvider.notifier)
                              .addSectionToCourse(
                                courseId: course.id,
                                sectionTitle: title,
                              );
                        }
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Section'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (course.sections.isEmpty)
                  Text(
                    'No sections added yet.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  ...course.sections.map(
                    (section) =>
                        _buildSectionWidget(course.id, section, colorScheme),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWidget(
    String courseId,
    CourseSection section,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ExpansionTile(
        title: Text(
          section.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_link, size: 18),
          tooltip: 'Add Resource',
          onPressed: () async {
            final data = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (_) => const AddResourceDialog(),
            );
            if (data != null) {
              ref
                  .read(academicControllerProvider.notifier)
                  .addResourceToSection(
                    courseId: courseId,
                    sectionId: section.id,
                    resourceTitle: data['title'] as String,
                    url: data['url'] as String,
                    type: data['type'] as ResourceType,
                    description: data['description'] as String?,
                  );
            }
          },
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: section.resources.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No resources in this section.',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : Column(
                    children: section.resources
                        .map((res) => ResourceItemTile(resource: res))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrientationTab(ColorScheme colorScheme) {
    final academicState = ref.watch(academicControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orientation Schedule',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Chronological schedule for upcoming orientation sessions.',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              academicState.orientationEvents.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text('No orientation events scheduled.'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return OrientationTimelineTile(
                        event: events[index],
                        isLast: index == events.length - 1,
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading schedule: $err',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
