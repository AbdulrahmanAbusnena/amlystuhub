import 'package:amlystuhub/features/announcements/presentation/widgets/announcement_creation.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/recent_announcement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  final Function(int)? onNavigateToTab;

  const DashboardScreen({super.key, this.onNavigateToTab});

  void _showCreateAnnouncementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateAnnouncementDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final user = userAsync.value;
    final isPrivilegedUser = user != null && user.role.canPublishAnnouncements;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner with Profile Welcome
                    _buildHeaderBanner(context, user?.name ?? 'Student'),
                    const SizedBox(height: 20),

                    // Grid Layout
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Primary Column (Announcements & Academic Overview)
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                RecentAnnouncementsWidget(
                                  onViewAllTap: () => onNavigateToTab?.call(1),
                                ),
                                const SizedBox(height: 20),
                                _buildAcademicOverviewWidget(context),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Sidebar Column (Quick Actions, Advocacy & Schedule)
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildQuickActionsWidget(
                                  context,
                                  isPrivilegedUser,
                                ),
                                const SizedBox(height: 20),
                                _buildAdvocacyWidget(context),
                                const SizedBox(height: 20),
                                _buildSchedulePreviewWidget(context),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildQuickActionsWidget(context, isPrivilegedUser),
                          const SizedBox(height: 16),
                          RecentAnnouncementsWidget(
                            onViewAllTap: () => onNavigateToTab?.call(1),
                          ),
                          const SizedBox(height: 16),
                          _buildAdvocacyWidget(context),
                          const SizedBox(height: 16),
                          _buildAcademicOverviewWidget(context),
                          const SizedBox(height: 16),
                          _buildSchedulePreviewWidget(context),
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

  Widget _buildHeaderBanner(BuildContext context, String userName) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, $userName',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your central hub for academic updates, student voice, and announcements.',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsWidget(BuildContext context, bool isPrivilegedUser) {
    final colorScheme = Theme.of(context).colorScheme;

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
                if (isPrivilegedUser)
                  ActionChip(
                    avatar: Icon(
                      Icons.add_comment_outlined,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    label: const Text('New Post'),
                    onPressed: () => _showCreateAnnouncementDialog(context),
                  ),
                ActionChip(
                  avatar: Icon(
                    Icons.campaign_outlined,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  label: const Text('Announcements'),
                  onPressed: () => onNavigateToTab?.call(1),
                ),
                ActionChip(
                  avatar: Icon(
                    Icons.school_outlined,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  label: const Text('Academics'),
                  onPressed: () => onNavigateToTab?.call(2),
                ),
                ActionChip(
                  avatar: Icon(
                    Icons.record_voice_over_outlined,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  label: const Text('Advocacy & Surveys'),
                  onPressed: () => onNavigateToTab?.call(3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvocacyWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advocacy & Student Voice',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.how_to_vote_outlined,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Voice your concerns or complete active StuCo policy surveys.',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '1 Active Survey Available',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateToTab?.call(3),
                    child: const Text('Open'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicOverviewWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Academic Hub',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => onNavigateToTab?.call(2),
                  child: const Text('Go to Hub'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.menu_book_outlined, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pre-AP & AP Resources',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Access subject entry guides and orientation packages.',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulePreviewWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Schedule',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildScheduleItem(
              context,
              time: 'Today',
              title: 'AP Course Orientation',
              subtitle: 'Student Center • 2:00 PM',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context, {
    required String time,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
