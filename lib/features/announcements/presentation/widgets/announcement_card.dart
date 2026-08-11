import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:amlystuhub/features/announcements/presentation/state/announcement_controller.dart';
import 'package:amlystuhub/features/announcements/presentation/widgets/announcement_creation.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnouncementCard extends ConsumerWidget {
  final AnnouncementModel announcement;

  const AnnouncementCard({super.key, required this.announcement});

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text(
          'Are you sure you want to delete this announcement? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await ref
                  .read(announcementControllerProvider.notifier)
                  .deleteAnnouncement(announcement.id);

              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete announcement.'),
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          CreateAnnouncementDialog(announcementToEdit: announcement),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserModelProvider);
    final user = currentUserAsync.value;
    final userId = user?.uid ?? '';
    final isPinned = announcement.pinnedByUids.contains(userId);
    final isPrivilegedUser = user != null && user.role.canPublishAnnouncements;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryBadge(context, announcement.category),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        color: isPinned
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      tooltip: isPinned
                          ? 'Unpin Announcement'
                          : 'Pin Announcement',
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
                    if (isPrivilegedUser)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditDialog(context);
                          } else if (value == 'delete') {
                            _confirmDelete(context, ref);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              announcement.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            MarkdownBody(
              data: announcement.content,
              onTapLink: (text, href, title) {
                if (href != null) {
                  Clipboard.setData(ClipboardData(text: href));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link copied to clipboard!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(
                    p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    a: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
            ),
            const SizedBox(height: 12),
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
