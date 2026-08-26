import 'package:amlystuhub/features/advocacy/presentation/state/advocacy_controller.dart';
import 'package:amlystuhub/features/advocacy/presentation/widgets/submit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/advocacy_models.dart';

import 'package:amlystuhub/features/advocacy/presentation/state/advocacy_controller.dart';
import 'package:amlystuhub/features/advocacy/presentation/widgets/submit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/advocacy_models.dart';

class TicketDetailDialog extends ConsumerStatefulWidget {
  final TicketModel ticket;
  final bool isLeadershipView;

  const TicketDetailDialog({
    super.key,
    required this.ticket,
    this.isLeadershipView = false,
  });

  @override
  ConsumerState<TicketDetailDialog> createState() => _TicketDetailDialogState();
}

class _TicketDetailDialogState extends ConsumerState<TicketDetailDialog> {
  late TicketStatus _currentStatus;
  late TextEditingController _noteController;

  double _dialogWidth = 600.0;
  double _dialogHeight = 670.0;

  static const double _minWidth = 450.0;
  static const double _maxWidth = 900.0;
  static const double _minHeight = 500.0;
  static const double _maxHeight = 850.0;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.ticket.status;
    _noteController = TextEditingController(
      text: widget.ticket.internalNote ?? '',
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _openEditDialog() async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => SubmitTicketDialog(ticketToEdit: widget.ticket),
    );

    if (mounted && updated == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveLeadershipChanges() async {
    final success = await ref
        .read(ticketManagementControllerProvider.notifier)
        .updateStatus(
          ticketId: widget.ticket.id,
          newStatus: _currentStatus,
          internalNote: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );

    if (mounted && success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket updated successfully.')),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Ticket'),
        content: const Text(
          'Are you sure you want to delete this ticket? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final bool success;
      if (widget.isLeadershipView) {
        success = await ref
            .read(ticketManagementControllerProvider.notifier)
            .deleteTicket(widget.ticket.id);
      } else {
        success = await ref
            .read(ticketSubmissionControllerProvider.notifier)
            .deleteTicket(widget.ticket.id);
      }

      if (mounted && success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ticket deleted.')));
      }
    }
  }

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.submitted:
        return Colors.blue;
      case TicketStatus.underReview:
        return Colors.orange;
      case TicketStatus.inProgress:
        return Colors.redAccent;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.dismissed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final managementState = ref.watch(ticketManagementControllerProvider);
    final submissionState = ref.watch(ticketSubmissionControllerProvider);
    final isLoading = managementState.isLoading || submissionState.isLoading;
    final theme = Theme.of(context);

    final canEdit =
        widget.isLeadershipView ||
        widget.ticket.status == TicketStatus.submitted;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: _dialogWidth,
        height: _dialogHeight,
        decoration: BoxDecoration(
          color: theme.dialogBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.ticket.subject,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(
                          Icons.circle,
                          size: 10,
                          color: _getStatusColor(widget.ticket.status),
                        ),
                        label: Text(widget.ticket.status.displayName),
                      ),
                      Chip(
                        avatar: const Icon(Icons.category_outlined, size: 14),
                        label: Text(widget.ticket.category.displayName),
                      ),
                      if (widget.ticket.apOnly)
                        const Chip(
                          avatar: Icon(Icons.school, size: 14),
                          label: Text('AP Only'),
                        ),
                      if (widget.ticket.isDiscreet)
                        const Chip(
                          avatar: Icon(Icons.security, size: 14),
                          label: Text('Discreet'),
                        ),
                    ],
                  ),
                  const Divider(height: 24),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Author Information',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.ticket.isDiscreet && !widget.isLeadershipView
                                ? 'Anonymous Student'
                                : '${widget.ticket.authorName} (${widget.ticket.authorEmail})',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),

                          Text(
                            'Description',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SelectableText(
                            widget.ticket.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (widget.isLeadershipView) ...[
                            const Divider(),
                            const SizedBox(height: 12),
                            Text(
                              'Leadership Actions (StuCo Admin)',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<TicketStatus>(
                              value: _currentStatus,
                              decoration: const InputDecoration(
                                labelText: 'Update Status',
                                border: OutlineInputBorder(),
                              ),
                              items: TicketStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status.displayName),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _currentStatus = val);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _noteController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Internal Leadership Note',
                                border: OutlineInputBorder(),
                                hintText:
                                    'Resolution notes or internal assignees...',
                              ),
                            ),
                          ] else if (widget.ticket.internalNote != null &&
                              widget.ticket.internalNote!.isNotEmpty) ...[
                            const Divider(),
                            const SizedBox(height: 12),
                            Text(
                              'Leadership Update Note',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.ticket.internalNote!,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      if (canEdit) ...[
                        IconButton(
                          tooltip: 'Delete Ticket',
                          icon: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error,
                          ),
                          onPressed: isLoading ? null : _confirmDelete,
                        ),
                        IconButton(
                          tooltip: 'Edit Details',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: isLoading ? null : _openEditDialog,
                        ),
                      ],
                      const Spacer(),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(
                          widget.isLeadershipView ? 'Cancel' : 'Close',
                        ),
                      ),
                      if (widget.isLeadershipView) ...[
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: isLoading ? null : _saveLeadershipChanges,
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Save Changes'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dialogWidth = (_dialogWidth + details.delta.dx).clamp(
                      _minWidth,
                      _maxWidth,
                    );
                    _dialogHeight = (_dialogHeight + details.delta.dy).clamp(
                      _minHeight,
                      _maxHeight,
                    );
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeDownRight,
                  child: Container(
                    width: 24,
                    height: 24,
                    color: Colors.transparent,
                    child: Icon(
                      Icons.south_east,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
