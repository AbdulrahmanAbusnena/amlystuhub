import 'package:amlystuhub/features/advocacy/presentation/widgets/create_surveys.dart';
import 'package:amlystuhub/features/advocacy/presentation/widgets/submit_dialog.dart';
import 'package:flutter/material.dart';

class AdvocacyHeader extends StatelessWidget {
  final bool isLeadership;

  const AdvocacyHeader({super.key, required this.isLeadership});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Advocacy & Voices',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  'Participate in active surveys, offer feedback to leadership, or submit concerns regarding school life and academics.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (isLeadership)
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const CreateSurveyDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Survey'),
              ),
            FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const SubmitTicketDialog(),
                );
              },
              icon: const Icon(Icons.campaign_outlined, size: 18),
              label: const Text('Submit Concern'),
            ),
          ],
        ),
      ],
    );
  }
}
