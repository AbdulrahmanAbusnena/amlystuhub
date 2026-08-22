import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_providers.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/add_course.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/add_resource.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/add_unit.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CourseDetailScreen extends ConsumerWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final isLeadership = userAsync.value?.role.canPublishAnnouncements ?? false;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(course.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'General & Exam Prep'),
              Tab(text: 'Units'),
            ],
          ),
          actions: [
            if (isLeadership)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'add_resource') {
                    showDialog(
                      context: context,
                      builder: (_) => AddResourceDialog(courseId: course.id),
                    );
                  } else if (value == 'add_unit') {
                    showDialog(
                      context: context,
                      builder: (_) => AddUnitDialog(courseId: course.id),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'add_resource',
                    child: Text('Add Resource'),
                  ),
                  const PopupMenuItem(
                    value: 'add_unit',
                    child: Text('Add Unit'),
                  ),
                ],
              ),
          ],
        ),
        body: TabBarView(
          children: [
            _GeneralResourcesTab(courseId: course.id),
            _UnitsTab(courseId: course.id, isLeadership: isLeadership),
          ],
        ),
      ),
    );
  }
}

class _GeneralResourcesTab extends ConsumerWidget {
  final String courseId;

  const _GeneralResourcesTab({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(generalResourcesStreamProvider(courseId));

    return resourcesAsync.when(
      data: (resources) {
        if (resources.isEmpty) {
          return const Center(
            child: Text('No course-wide resources or exam tips added yet.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final res = resources[index];
            return _ResourceCard(resource: res);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _UnitsTab extends ConsumerWidget {
  final String courseId;
  final bool isLeadership;

  const _UnitsTab({required this.courseId, required this.isLeadership});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsAsync = ref.watch(unitsStreamProvider(courseId));

    return unitsAsync.when(
      data: (units) {
        if (units.isEmpty) {
          return const Center(
            child: Text('No units created for this course yet.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: units.length,
          itemBuilder: (context, index) {
            final unit = units[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text(
                  'Unit ${unit.unitNumber}: ${unit.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: unit.description.isNotEmpty
                    ? Text(unit.description)
                    : null,
                trailing: isLeadership
                    ? IconButton(
                        icon: const Icon(Icons.add_link),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AddResourceDialog(
                              courseId: courseId,
                              defaultUnitId: unit.id,
                            ),
                          );
                        },
                      )
                    : null,
                children: [
                  _UnitResourcesList(courseId: courseId, unitId: unit.id),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _UnitResourcesList extends ConsumerWidget {
  final String courseId;
  final String unitId;

  const _UnitResourcesList({required this.courseId, required this.unitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(
      unitResourcesStreamProvider((courseId: courseId, unitId: unitId)),
    );

    return resourcesAsync.when(
      data: (resources) {
        if (resources.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No resources uploaded for this unit yet.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
            ),
          );
        }

        return Column(
          children: resources
              .map(
                (res) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: _ResourceCard(resource: res),
                ),
              )
              .toList(),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
      error: (err, _) => Text('Error loading unit resources: $err'),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final ResourceModel resource;

  const _ResourceCard({required this.resource});

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  IconData _getIconForType(ResourceType type) {
    switch (type) {
      case ResourceType.pdf:
        return Icons.picture_as_pdf;
      case ResourceType.googleDrive:
        return Icons.folder_shared;
      case ResourceType.video:
        return Icons.video_library;
      case ResourceType.link:
      default:
        return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(_getIconForType(resource.type), size: 20),
        ),
        title: Text(
          resource.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: resource.tag != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Chip(
                  label: Text(
                    resource.tag!,
                    style: const TextStyle(fontSize: 10),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              )
            : null,
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => _launchUrl(resource.url),
      ),
    );
  }
}
