import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/models/resource_item_model.dart';

class ResourceTile extends ConsumerWidget {
  final AcademicResourceModel resource;

  const ResourceTile({super.key, required this.resource});

  Future<void> _launchUrl(BuildContext context) async {
    final uri = Uri.parse(resource.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open external link')),
        );
      }
    }
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: resource.url));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Link copied to clipboard')));
  }

  IconData _getTypeIcon() {
    switch (resource.type) {
      case AcademicResourceType.googleDoc:
        return Icons.description_outlined;
      case AcademicResourceType.googleDrive:
        return Icons.folder_zip_outlined;
      case AcademicResourceType.youtube:
        return Icons.play_circle_outline;
      case AcademicResourceType.pdfDownload:
        return Icons.picture_as_pdf_outlined;
      case AcademicResourceType.externalLink:
        return Icons.language_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUser = ref.watch(currentUserModelProvider).value;
    final currentUserId = currentUser?.uid ?? '';
    final hasUpvoted = resource.helpfulUserIds.contains(currentUserId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(_getTypeIcon(), color: colorScheme.primary, size: 20),
        ),
        title: Text(
          resource.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resource.description.isNotEmpty)
              Text(
                resource.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (resource.isOfflinePdf)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PDF Download',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Helpful / Upvote Button
            IconButton(
              icon: Icon(
                hasUpvoted ? Icons.thumb_up : Icons.thumb_up_outlined,
                size: 16,
                color: hasUpvoted
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              tooltip: 'Helpful',
              onPressed: currentUserId.isEmpty
                  ? null
                  : () {
                      ref
                          .read(academicsControllerProvider.notifier)
                          .toggleHelpfulRating(resource.id, currentUserId);
                    },
            ),
            Text(
              '${resource.helpfulCount}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),

            // Copy Link Action
            IconButton(
              icon: const Icon(Icons.copy_outlined, size: 16),
              tooltip: 'Copy Link',
              onPressed: () => _copyLink(context),
            ),

            // Direct Launch Action
            IconButton(
              icon: const Icon(Icons.open_in_new_outlined, size: 16),
              tooltip: 'Open Link',
              onPressed: () => _launchUrl(context),
            ),
          ],
        ),
        onTap: () => _launchUrl(context),
      ),
    );
  }
}
