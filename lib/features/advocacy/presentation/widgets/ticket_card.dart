import 'package:flutter/material.dart';
import '../../domain/models/advocacy_models.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
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
              TicketStatusBadge(status: ticket.status),
              const Spacer(),
              if (ticket.isDiscreet)
                Tooltip(
                  message: 'Submitted discreetly',
                  child: Icon(
                    Icons.security,
                    size: 16,
                    color: colorScheme.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ticket.subject,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ticket.category.displayName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TicketStatusBadge extends StatelessWidget {
  final TicketStatus status;

  const TicketStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bg;
    Color fg;

    switch (status) {
      case TicketStatus.submitted:
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade800;
        break;
      case TicketStatus.underReview:
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade900;
        break;
      case TicketStatus.inProgress:
        bg = Colors.purple.shade50;
        fg = Colors.purple.shade800;
        break;
      case TicketStatus.resolved:
        bg = Colors.green.shade50;
        fg = Colors.green.shade800;
        break;
      case TicketStatus.dismissed:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.displayName,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
