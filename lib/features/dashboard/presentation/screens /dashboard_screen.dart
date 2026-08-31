import 'package:amlystuhub/features/announcements/presentation/widgets/announcement_creation.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/dashboard/domain/models/ui_vibes.dart';
import 'package:amlystuhub/features/dashboard/presentation/providers/vibe_provider.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/recent_announcement.dart';

import 'package:amlystuhub/features/dashboard/presentation/widget/cozy_view.dart';
import 'package:amlystuhub/features/dashboard/presentation/widget/custom_top_nav.dart';
import 'package:amlystuhub/features/dashboard/presentation/widget/dense_view.dart';
import 'package:amlystuhub/features/dashboard/presentation/widget/minimalist_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final Function(int)? onNavigateToTab;

  const DashboardScreen({super.key, this.onNavigateToTab});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateAnnouncementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateAnnouncementDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vibe = ref.watch(uiVibeProvider);

    // Delegate to alternative view widgets if non-standard vibe selected
    switch (vibe) {
      case UiVibe.minimalist:
        return MinimalistDashboardView(onNavigateToTab: widget.onNavigateToTab);
      case UiVibe.dense:
        return DenseDashboardView(onNavigateToTab: widget.onNavigateToTab);
      case UiVibe.cozyPastel:
        return CozyPastelDashboardView(onNavigateToTab: widget.onNavigateToTab);
      case UiVibe.standard:
      default:
        break; // Continue to render standard layout below
    }

    final userAsync = ref.watch(currentUserModelProvider);
    final user = userAsync.value;
    final isPrivilegedUser = user != null && user.role.canPublishAnnouncements;
    final isStuCoAdmin = user != null && user.isStuCoAdmin;

    return Scaffold(
      appBar: CustomTopNavBar(onNavigateToTab: widget.onNavigateToTab),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 960;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24.0 : 16.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner with Real-Time Search Bar
                    _buildHeaderBannerWithSearch(
                      context,
                      user?.name ?? 'Student',
                    ),
                    const SizedBox(height: 24),

                    // Active Search Filter Bar Indicator
                    if (_searchQuery.isNotEmpty) ...[
                      _buildSearchIndicatorBar(context),
                      const SizedBox(height: 16),
                    ],

                    // Layout Grid
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Primary Column (Filtered Announcements & Academic Hub)
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                RecentAnnouncementsWidget(
                                  onViewAllTap: () =>
                                      widget.onNavigateToTab?.call(1),
                                ),
                                const SizedBox(height: 20),
                                _buildAcademicOverviewWidget(context),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),

                          // Sidebar Panel
                          Expanded(
                            flex: 2,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildQuickActionsSection(
                                      context,
                                      isPrivilegedUser,
                                      isStuCoAdmin,
                                    ),
                                    const Divider(height: 32),
                                    _buildScheduleSection(context),
                                    const Divider(height: 32),
                                    _buildStuCoContactsSection(context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildQuickActionsSection(
                                context,
                                isPrivilegedUser,
                                isStuCoAdmin,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          RecentAnnouncementsWidget(
                            onViewAllTap: () => widget.onNavigateToTab?.call(1),
                          ),
                          const SizedBox(height: 16),
                          _buildAcademicOverviewWidget(context),
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildScheduleSection(context),
                            ),
                          ),
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

  Widget _buildHeaderBannerWithSearch(BuildContext context, String userName) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
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
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search announcements by title or content...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchIndicatorBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt_outlined, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Filtering results by: "$_searchQuery"',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
            child: Text(
              'Clear filter',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(
    BuildContext context,
    bool isPrivilegedUser,
    bool isStuCoAdmin,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
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
              onPressed: () => widget.onNavigateToTab?.call(1),
            ),
            ActionChip(
              avatar: Icon(
                Icons.school_outlined,
                size: 16,
                color: colorScheme.primary,
              ),
              label: const Text('Academics'),
              onPressed: () => widget.onNavigateToTab?.call(2),
            ),
            ActionChip(
              avatar: Icon(
                Icons.record_voice_over_outlined,
                size: 16,
                color: colorScheme.primary,
              ),
              label: const Text('Advocacy'),
              onPressed: () => widget.onNavigateToTab?.call(3),
            ),
            ActionChip(
              avatar: Icon(
                Icons.person_outline,
                size: 16,
                color: colorScheme.primary,
              ),
              label: const Text('Profile'),
              onPressed: () => widget.onNavigateToTab?.call(4),
            ),
            if (isStuCoAdmin)
              ActionChip(
                avatar: Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 16,
                  color: colorScheme.error,
                ),
                label: const Text('Profile Requests'),
                onPressed: () => context.go('/admin/profile-requests'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Schedule',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
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
                  'Sep 6',
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
                    const Text(
                      'AP Course Orientation',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Student Center • 2:00 PM',
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
    );
  }

  Widget _buildStuCoContactsSection(BuildContext context) {
    final leads = [
      {'dept': 'Academic Dept', 'lead': 'Head of Academics'},
      {'dept': 'AP Academics', 'lead': 'Head of AP'},
      {'dept': 'Technology Dept', 'lead': 'Head of Tech'},
      {'dept': 'Advocacy Board', 'lead': 'Policy Lead'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student Council Leads',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leads.length,
          separatorBuilder: (context, index) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final item = leads[index];
            return _buildContactTile(
              context,
              title: item['dept']!,
              lead: item['lead']!,
            );
          },
        ),
      ],
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required String title,
    required String lead,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.shield_outlined, size: 16, color: colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          lead,
          style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildAcademicOverviewWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
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
                  onPressed: () => widget.onNavigateToTab?.call(2),
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
                  color: colorScheme.outline.withValues(alpha: 0.3),
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
                          'AP Resources',
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
}
