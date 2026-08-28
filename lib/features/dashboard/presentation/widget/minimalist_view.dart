import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/recent_announcement.dart';
import 'package:amlystuhub/features/dashboard/presentation/widget/custom_top_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MinimalistDashboardView extends ConsumerWidget {
  final Function(int)? onNavigateToTab;

  const MinimalistDashboardView({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final user = userAsync.value;

    return Scaffold(
      appBar: CustomTopNavBar(onNavigateToTab: onNavigateToTab),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minimal Header
                Text(
                  user?.name ?? 'Student',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Academic & Governance Overview',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(height: 1),
                const SizedBox(height: 24),

                // Navigation Row Shortcuts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTextShortcut(
                      context,
                      label: 'Announcements',
                      onTap: () => onNavigateToTab?.call(1),
                    ),
                    _buildTextShortcut(
                      context,
                      label: 'Academics',
                      onTap: () => onNavigateToTab?.call(2),
                    ),
                    _buildTextShortcut(
                      context,
                      label: 'Advocacy',
                      onTap: () => onNavigateToTab?.call(3),
                    ),
                    _buildTextShortcut(
                      context,
                      label: 'Profile',
                      onTap: () => onNavigateToTab?.call(4),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 32),

                // Main Feed Content
                RecentAnnouncementsWidget(
                  onViewAllTap: () => onNavigateToTab?.call(1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextShortcut(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
