import 'package:amlystuhub/features/academics/presentation/screens/course_detail_screen.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcademicHubScreen extends ConsumerWidget {
  const AcademicHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesStreamProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Academic Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: coursesAsync.when(
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(
              child: Text('No academic courses published yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Row(
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (course.isAp)
                        Chip(
                          label: const Text(
                            'AP',
                            style: TextStyle(fontSize: 10),
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: colorScheme.primaryContainer,
                        ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      course.description,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CourseDetailScreen(course: course),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load courses: $err')),
      ),
    );
  }
}
