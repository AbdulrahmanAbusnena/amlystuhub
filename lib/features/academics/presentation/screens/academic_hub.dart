import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/subject_card.dart';

class AcademicHubScreen extends ConsumerStatefulWidget {
  const AcademicHubScreen({super.key});

  @override
  ConsumerState<AcademicHubScreen> createState() => _AcademicHubScreenState();
}

class _AcademicHubScreenState extends ConsumerState<AcademicHubScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final academicState = ref.watch(academicControllerProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Announcement Banner Integration
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: colorScheme.primaryContainer,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.campaign,
                            color: colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Academic Advisory Announcement',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Orientation schedules, course guides, and exam preparation materials are updated weekly by the Academic Department.',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onPrimaryContainer.withValues(
                            alpha: 0.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips Bar
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children:
                    [
                          'All',
                          'AP Courses',
                          'High School General',
                          'Guides & Orientation',
                        ]
                        .map(
                          (cat) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: _selectedCategory == cat,
                              selectedColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              labelStyle: TextStyle(
                                color: _selectedCategory == cat
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: _selectedCategory == cat
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedCategory = cat);
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Course & Subject Grid
          academicState.courses.when(
            data: (courses) {
              final filtered = courses.where((c) {
                if (_selectedCategory == 'AP Courses') return c.isAp;
                if (_selectedCategory == 'High School General') return !c.isAp;
                return true;
              }).toList();

              if (filtered.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No courses found in this category.'),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final course = filtered[index];
                    return SubjectCard(
                      course: course,
                      onTap: () {
                        // Opens subject details modal with native in-app resource tiles
                      },
                    );
                  }, childCount: filtered.length),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => SliverFillRemaining(
              child: Center(child: Text('Error loading subjects: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
