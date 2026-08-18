import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceItemTile extends StatelessWidget {
  final AcademicResource resource;

  const ResourceItemTile({super.key, required this.resource});

  IconData _getIconForType(ResourceType type) {
    switch (type) {
      case ResourceType.driveFolder:
        return Icons.folder_outlined;
      case ResourceType.driveDoc:
        return Icons.description_outlined;
      case ResourceType.pdf:
        return Icons.picture_as_pdf_outlined;
      case ResourceType.richText:
        return Icons.article_outlined;
      case ResourceType.externalLink:
        return Icons.link_outlined;
    }
  }

  Color _getIconColor(ResourceType type, ColorScheme colorScheme) {
    switch (type) {
      case ResourceType.driveFolder:
      case ResourceType.driveDoc:
        return const Color(0xFF0F9D58);
      case ResourceType.pdf:
        return const Color(0xFFDB4437);
      case ResourceType.richText:
        return colorScheme.primary;
      case ResourceType.externalLink:
        return colorScheme.secondary;
    }
  }

  Future<void> _openUrl(BuildContext context) async {
    if (resource.url.isEmpty) return;
    final uri = Uri.parse(resource.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch ${resource.url}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = _getIconColor(resource.type, colorScheme);

    return InkWell(
      onTap: () => _openUrl(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _getIconForType(resource.type),
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  if (resource.description != null &&
                      resource.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      resource.description!,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_outward,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
