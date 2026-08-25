import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/advocacy_models.dart';
import '../state/advocacy_controller.dart';

class SubmitTicketDialog extends ConsumerStatefulWidget {
  const SubmitTicketDialog({super.key});

  @override
  ConsumerState<SubmitTicketDialog> createState() => _SubmitTicketDialogState();
}

class _SubmitTicketDialogState extends ConsumerState<SubmitTicketDialog> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  TicketCategory _selectedCategory = TicketCategory.academics;
  bool _isDiscreet = false;
  bool _apOnly = false;
  bool _isLoading = false;

  double _dialogWidth = 580.0;
  double _dialogHeight = 620.0;

  static const double _minWidth = 450.0;
  static const double _maxWidth = 900.0;
  static const double _minHeight = 500.0;
  static const double _maxHeight = 800.0;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_subjectController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty)
      return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(ticketSubmissionControllerProvider.notifier)
        .submitTicket(
          category: _selectedCategory,
          subject: _subjectController.text,
          description: _descriptionController.text,
          isDiscreet: _isDiscreet,
          apOnly: _apOnly,
        );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(ticketSubmissionControllerProvider);
    final isSubmitting = _isLoading || controllerState.isLoading;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: _dialogWidth,
        height: _dialogHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                        'Submit a Concern or Report',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _subjectController,
                            decoration: const InputDecoration(
                              labelText: 'Subject / Summary',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<TicketCategory>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            items: TicketCategory.values.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat.displayName),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null)
                                setState(() => _selectedCategory = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _descriptionController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              labelText: 'Details / Report Description',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('AP-Specific Concern'),
                            subtitle: const Text(
                              'Check if this relates to Advanced Placement courses or exams',
                            ),
                            value: _apOnly,
                            onChanged: (val) =>
                                setState(() => _apOnly = val ?? false),
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Discreet Submission'),
                            subtitle: const Text(
                              'Conceals name from regular viewing (Maintains admin audit trail)',
                            ),
                            value: _isDiscreet,
                            onChanged: (val) =>
                                setState(() => _isDiscreet = val ?? false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: isSubmitting ? null : _submit,
                        child: isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Submit Ticket'),
                      ),
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
