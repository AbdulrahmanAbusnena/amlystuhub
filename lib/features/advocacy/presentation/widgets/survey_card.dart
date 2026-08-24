import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../domain/models/advocacy_models.dart';

class SurveyCard extends StatelessWidget {
  final SurveyModel survey;

  const SurveyCard({super.key, required this.survey});

  Future<void> _launchSurveyUrl() async {
    if (await canLaunchUrlString(survey.googleFormUrl)) {
      await launchUrlString(
        survey.googleFormUrl,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Grade ${survey.targetGrade}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.assignment_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            survey.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (survey.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              survey.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _launchSurveyUrl,
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Open Form'),
            ),
          ),
        ],
      ),
    );
  }
}
