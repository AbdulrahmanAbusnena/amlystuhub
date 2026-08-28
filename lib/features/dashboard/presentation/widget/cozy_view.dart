import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/recent_announcement.dart';
import 'package:amlystuhub/features/dashboard/presentation/widget/custom_top_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CozyPastelDashboardView extends ConsumerWidget {
  final Function(int)? onNavigateToTab;

  const CozyPastelDashboardView({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final user = userAsync.value;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF4F0), // Soft warm pastel base
      appBar: CustomTopNavBar(onNavigateToTab: onNavigateToTab),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warm Welcoming Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8EE), // Pastel rose tint
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user?.name ?? 'Friend'} 👋',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3E3D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ready to check out your school updates and resources today?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7A6E6D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Pill Navigation Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPillChip(
                        context,
                        label: 'Announcements',
                        icon: Icons.campaign_rounded,
                        color: const Color(0xFFE2ECE9),
                        onTap: () => onNavigateToTab?.call(1),
                      ),
                      const SizedBox(width: 12),
                      _buildPillChip(
                        context,
                        label: 'Academics',
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFFEAE4F2),
                        onTap: () => onNavigateToTab?.call(2),
                      ),
                      const SizedBox(width: 12),
                      _buildPillChip(
                        context,
                        label: 'Advocacy',
                        icon: Icons.bubble_chart_rounded,
                        color: const Color(0xFFFCEAE6),
                        onTap: () => onNavigateToTab?.call(3),
                      ),
                      const SizedBox(width: 12),
                      _buildPillChip(
                        context,
                        label: 'Profile',
                        icon: Icons.person_rounded,
                        color: const Color(0xFFFFF2D6),
                        onTap: () => onNavigateToTab?.call(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Announcements Container Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: RecentAnnouncementsWidget(
                    onViewAllTap: () => onNavigateToTab?.call(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF4A3E3D)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF4A3E3D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
