import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Banner / Quick Header Context
                    _buildHeaderBanner(context),
                    const SizedBox(height: 20),

                    // Dynamic Grid Layout based on Screen Width
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main Column (Announcements & Academic Overview)
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                _buildAnnouncementsPreviewWidget(),
                                const SizedBox(height: 20),
                                _buildAcademicOverviewWidget(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Side Column (Schedule, Quick Actions)
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildQuickActionsWidget(context),
                                const SizedBox(height: 20),
                                _buildSchedulePreviewWidget(),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      // Mobile / Tablet Single Column Stack
                      Column(
                        children: [
                          _buildQuickActionsWidget(context),
                          const SizedBox(height: 16),
                          _buildAnnouncementsPreviewWidget(),
                          const SizedBox(height: 16),
                          _buildSchedulePreviewWidget(),
                          const SizedBox(height: 16),
                          _buildAcademicOverviewWidget(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here is an overview of updates, upcoming schedules, and announcements.',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsWidget(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.campaign, size: 18),
                  label: const Text('Post Announcement'),
                  onPressed: () {},
                ),
                ActionChip(
                  avatar: const Icon(Icons.event, size: 18),
                  label: const Text('Schedule'),
                  onPressed: () {},
                ),
                ActionChip(
                  avatar: const Icon(Icons.school, size: 18),
                  label: const Text('Academic Hub'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementsPreviewWidget() {
    return Card(
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: const Text('Announcements Preview Widget (Phase 3B)'),
      ),
    );
  }

  Widget _buildSchedulePreviewWidget() {
    return Card(
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: const Text('Schedule & Deadlines Widget (Phase 3B)'),
      ),
    );
  }

  Widget _buildAcademicOverviewWidget() {
    return Card(
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: const Text('Academic Overview Widget (Phase 3B)'),
      ),
    );
  }
}
