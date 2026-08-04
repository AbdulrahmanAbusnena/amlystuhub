import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amlystuhub/features/announcements/presentation/state/announcement_controller.dart';

class AnnouncementCard extends ConsumerWidget {
  final AnnouncementModel announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserModelProvider);
    final userId = currentUserAsync.value?.uid ?? '';
    final isPinned = announcement.pinnedByUids.contains(userId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Category Badge, Pin Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryBadge(context, announcement.category),
                IconButton(
                  icon: Icon(
                    isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: isPinned
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  tooltip: isPinned ? 'Unpin Announcement' : 'Pin Announcement',
                  onPressed: userId.isEmpty
                      ? null
                      : () {
                          ref
                              .read(announcementControllerProvider.notifier)
                              .togglePin(
                                announcementId: announcement.id,
                                userId: userId,
                                currentlyPinned: isPinned,
                              );
                        },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              announcement.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // Content
            Text(
              announcement.content,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Target Audience Badges (Grades & AP Flag)
            if (announcement.targetGrades.isNotEmpty || announcement.apOnly)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (announcement.apOnly)
                    _buildScopeChip(
                      context,
                      'AP Students Only',
                      Colors.deepPurple,
                    ),
                  for (final grade in announcement.targetGrades)
                    _buildScopeChip(context, 'Grade $grade', Colors.blueGrey),
                ],
              ),
            if (announcement.targetGrades.isNotEmpty || announcement.apOnly)
              const SizedBox(height: 12),

            const Divider(height: 1),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  announcement.authorName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 6),
                _buildRoleBadge(
                  context,
                  announcement.authorRole.toSystemString(),
                ),
                const Spacer(),
                Text(
                  _formatDate(announcement.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context, String category) {
    Color badgeColor;
    switch (category.toLowerCase()) {
      case 'ap':
        badgeColor = Colors.deepPurple;
        break;
      case 'exam':
        badgeColor = Colors.redAccent;
        break;
      case 'stuco':
        badgeColor = Colors.orangeAccent;
        break;
      case 'emergency':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildScopeChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context, String roleStr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        roleStr.replaceAll('_', ' ').toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
