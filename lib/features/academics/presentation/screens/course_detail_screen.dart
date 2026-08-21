import 'package:amlystuhub/features/academics/domain/models/academic_course_model.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/resource_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/models/resource_item_model.dart' show AcademicResourceType;

class CourseDetailScreen extends ConsumerWidget {
  final AcademicCourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  Future<void> _launchDriveFolder() async {
    if (course.mainDriveFolderUrl.isEmpty) return;
    final uri = Uri.parse(course.mainDriveFolderUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final unitsAsync = ref.watch(courseUnitsStreamProvider(course.id));
    final resourcesAsync = ref.watch(courseResourcesStreamProvider(course.id));
    final activeFilter = ref.watch(selectedResourceTypeFilterProvider);

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Drive Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_shared_outlined,
                      size: 36,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Main Drive Folder',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Access full course materials, syllabus, and shared drives.',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: course.mainDriveFolderUrl.isNotEmpty
                          ? _launchDriveFolder
                          : null,
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Open'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Resource Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All Types'),
                    selected: activeFilter == null,
                    onSelected: (_) {
                      ref
                              .read(selectedResourceTypeFilterProvider.notifier)
                              .state =
                          null;
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Google Docs'),
                    selected: activeFilter == AcademicResourceType.googleDoc,
                    onSelected: (_) {
                      ref
                              .read(selectedResourceTypeFilterProvider.notifier)
                              .state =
                          AcademicResourceType.googleDoc;
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('YouTube'),
                    selected: activeFilter == AcademicResourceType.youtube,
                    onSelected: (_) {
                      ref
                              .read(selectedResourceTypeFilterProvider.notifier)
                              .state =
                          AcademicResourceType.youtube;
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('PDF Downloads'),
                    selected: activeFilter == AcademicResourceType.pdfDownload,
                    onSelected: (_) {
                      ref
                              .read(selectedResourceTypeFilterProvider.notifier)
                              .state =
                          AcademicResourceType.pdfDownload;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Units Accordion Feed
            unitsAsync.when(
              data: (units) {
                if (units.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text('No units added for this course yet.'),
                    ),
                  );
                }

                return resourcesAsync.when(
                  data: (resources) {
                    return Column(
                      children: units.map((unit) {
                        final unitResources = resources.where((r) {
                          final matchesUnit = r.unitId == unit.id;
                          final matchesFilter =
                              activeFilter == null || r.type == activeFilter;
                          return matchesUnit && matchesFilter;
                        }).toList();

                        return ExpansionTile(
                          key: PageStorageKey(unit.id),
                          title: Text(
                            'Unit ${unit.unitNumber}: ${unit.title}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: unit.description.isNotEmpty
                              ? Text(
                                  unit.description,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : null,
                          children: unitResources.isEmpty
                              ? [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'No resources available under this unit filter.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ]
                              : unitResources
                                    .map((r) => ResourceTile(resource: r))
                                    .toList(),
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('Error loading resources: $err'),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading units: $err'),
            ),
          ],
        ),
      ),
    );
  }
}
