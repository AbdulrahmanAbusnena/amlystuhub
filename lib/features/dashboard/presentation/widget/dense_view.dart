import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/recent_announcement.dart';
import 'package:amlystuhub/features/dashboard/presentation/widget/custom_top_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DenseDashboardView extends ConsumerWidget {
  final Function(int)? onNavigateToTab;

  const DenseDashboardView({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final user = userAsync.value;
    final isStuCoAdmin = user != null && user.isStuCoAdmin;

    return Scaffold(
      appBar: CustomTopNavBar(onNavigateToTab: onNavigateToTab),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Compact Header Status Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'USER: ${user?.name.toUpperCase() ?? 'STUDENT'}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const Spacer(),
                      if (isStuCoAdmin)
                        InkWell(
                          onTap: () => context.go('/admin/profile-requests'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            color: Theme.of(context).colorScheme.errorContainer,
                            child: Text(
                              'ADMIN QUEUE ACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Multi-Column Grid Layout
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1: Announcements Feed
                    Expanded(
                      flex: 3,
                      child: RecentAnnouncementsWidget(
                        onViewAllTap: () => onNavigateToTab?.call(1),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Column 2: Compact Action Controls
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SYSTEM CONTROLS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 16),
                            _buildDenseActionButton(
                              context,
                              label: 'ANNOUNCEMENTS HUB',
                              icon: Icons.campaign_outlined,
                              onTap: () => onNavigateToTab?.call(1),
                            ),
                            _buildDenseActionButton(
                              context,
                              label: 'ACADEMIC RESOURCES',
                              icon: Icons.school_outlined,
                              onTap: () => onNavigateToTab?.call(2),
                            ),
                            _buildDenseActionButton(
                              context,
                              label: 'ADVOCACY BOARD',
                              icon: Icons.record_voice_over_outlined,
                              onTap: () => onNavigateToTab?.call(3),
                            ),
                            _buildDenseActionButton(
                              context,
                              label: 'USER PROFILE',
                              icon: Icons.person_outline,
                              onTap: () => onNavigateToTab?.call(4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDenseActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 14),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
