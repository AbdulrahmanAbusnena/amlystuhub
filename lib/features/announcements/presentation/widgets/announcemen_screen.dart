import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:amlystuhub/features/announcements/presentation/state/announcement_controller.dart';
import 'package:amlystuhub/features/announcements/presentation/widgets/announcement_creation.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnouncementCard extends ConsumerStatefulWidget {
  final AnnouncementModel announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  ConsumerState<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends ConsumerState<AnnouncementCard> {
  bool _isHovered = false;

  void _confirmDelete(BuildContext context) {
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
                  .deleteAnnouncement(widget.announcement.id);

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
          CreateAnnouncementDialog(announcementToEdit: widget.announcement),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUserAsync = ref.watch(currentUserModelProvider);
    final user = currentUserAsync.value;
    final userId = user?.uid ?? '';
    final isPinned = widget.announcement.pinnedByUids.contains(userId);
    final isPrivilegedUser = user != null && user.role.canPublishAnnouncements;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered || isPinned
                    ? colorScheme.primary.withValues(alpha: 0.5)
                    : colorScheme.outlineVariant.withValues(alpha: 0.6),
                width: isPinned || _isHovered ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? colorScheme.primary.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: _isHovered ? 12 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Category Badge & Actions (Pin / Menu)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryBadge(
                            context,
                            widget.announcement.category,
                          ),
                          Row(
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  isPinned
                                      ? Icons.push_pin
                                      : Icons.push_pin_outlined,
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
                                            .read(
                                              announcementControllerProvider
                                                  .notifier,
                                            )
                                            .togglePin(
                                              announcementId:
                                                  widget.announcement.id,
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
                                      _confirmDelete(context);
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
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        widget.announcement.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Body Content
                      MarkdownBody(
                        data: widget.announcement.content,
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
                        styleSheet: MarkdownStyleSheet.fromTheme(theme)
                            .copyWith(
                              p: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.9,
                                ),
                                height: 1.45,
                              ),
                              a: TextStyle(
                                color: colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                      ),
                      const SizedBox(height: 14),

                      // Scope / Target Chips
                      if (widget.announcement.targetGrades.isNotEmpty ||
                          widget.announcement.apOnly) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (widget.announcement.apOnly)
                              _buildScopeChip(
                                context,
                                'AP Students',
                                colorScheme.primary,
                                Icons.stars_outlined,
                              ),
                            for (final grade
                                in widget.announcement.targetGrades)
                              _buildScopeChip(
                                context,
                                'Grade $grade',
                                colorScheme.secondary,
                                Icons.school_outlined,
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],

                      Divider(
                        height: 1,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Footer
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: colorScheme.primary.withValues(
                              alpha: 0.15,
                            ),
                            child: Text(
                              widget.announcement.authorName.isNotEmpty
                                  ? widget.announcement.authorName[0]
                                        .toUpperCase()
                                  : 'S',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.announcement.authorName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _buildRoleBadge(
                            context,
                            widget.announcement.authorRole.toSystemString(),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.access_time,
                            size: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(widget.announcement.createdAt),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context, String category) {
    final colorScheme = Theme.of(context).colorScheme;
    Color color;
    IconData icon;

    switch (category.toLowerCase()) {
      case 'academic':
        color = const Color(0xFF0284C7);
        icon = Icons.school_outlined;
        break;
      case 'ap':
        color = const Color(0xFF7C3AED);
        icon = Icons.auto_awesome_outlined;
        break;
      case 'stuco':
        color = const Color(0xFFD97706);
        icon = Icons.shield_outlined;
        break;
      case 'urgent':
        color = colorScheme.error;
        icon = Icons.warning_amber_rounded;
        break;
      case 'event':
        color = const Color(0xFF059669);
        icon = Icons.event_outlined;
        break;
      case 'general':
      default:
        color = const Color(0xFF2563EB);
        icon = Icons.campaign_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            category.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScopeChip(
    BuildContext context,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
