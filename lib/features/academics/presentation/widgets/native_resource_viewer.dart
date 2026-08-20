import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NativeResourceViewer {
  static void show(BuildContext context, AcademicResource resource) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    resource.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (resource.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      resource.description!,
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                  const Divider(height: 32),
                  if (resource.richTextContent != null &&
                      resource.richTextContent!.isNotEmpty) ...[
                    Text(
                      resource.richTextContent!,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ] else ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'Document preview ready for download or external viewing.',
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (resource.url != null && resource.url!.isNotEmpty)
                    FilledButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(resource.url!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: Text(
                        resource.type == ResourceType.driveFolder
                            ? 'Open Complete Drive Folder'
                            : 'Open Source Link',
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
