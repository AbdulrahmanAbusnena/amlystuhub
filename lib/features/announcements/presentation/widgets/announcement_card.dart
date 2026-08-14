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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUserAsync = ref.watch(currentUserModelProvider);
    final user = currentUserAsync.value;
    final userId = user?.uid ?? '';
    final isPinned = announcement.pinnedByUids.contains(userId);
    final isPrivilegedUser = user != null && user.role.canPublishAnnouncements;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category Badge & Actions (Pin / Menu)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryBadge(context, announcement.category),
                Row(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        size: 20,
                        color: isPinned
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
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
                        icon: Icon(
                          Icons.more_vert,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
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
                                Icon(Icons.edit_outlined, size: 18),
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
                                  size: 18,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: colorScheme.error,
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
            const SizedBox(height: 10),

            // Title
            Text(
              announcement.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // Body / Markdown Content
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
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.9),
                  height: 1.45,
                ),
                a: TextStyle(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Scope / Target Chips
            if (announcement.targetGrades.isNotEmpty || announcement.apOnly) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  if (announcement.apOnly)
                    _buildScopeChip(
                      context,
                      'AP Students Only',
                      colorScheme.primary,
                    ),
                  for (final grade in announcement.targetGrades)
                    _buildScopeChip(
                      context,
                      'Grade $grade',
                      colorScheme.secondary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            Divider(height: 1, color: colorScheme.outlineVariant),
            const SizedBox(height: 10),

            // Footer (Author, Role, Date)
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 15,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  announcement.authorName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
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
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context, String category) {
    final colorScheme = Theme.of(context).colorScheme;
    Color badgeColor;

    switch (category.toLowerCase()) {
      case 'academic':
        badgeColor = colorScheme.primary;
        break;
      case 'ap':
        badgeColor = const Color(0xFF8B5CF6); // Distinct Purple
        break;
      case 'stuco':
        badgeColor = const Color(0xFFF59E0B); // Amber / Orange
        break;
      case 'general':
      default:
        badgeColor = colorScheme.secondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildScopeChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        roleStr.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}