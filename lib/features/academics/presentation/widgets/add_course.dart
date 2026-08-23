import 'package:amlystuhub/features/academics/presentation/state/academic_providers.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCourseDialog extends ConsumerStatefulWidget {
  const AddCourseDialog({super.key});

  @override
  ConsumerState<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends ConsumerState<AddCourseDialog> {
  final _titleController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _orderController = TextEditingController(text: '0');

  String _category = 'AP';
  bool _isLoading = false;

  double _dialogWidth = 560.0;
  double _dialogHeight = 520.0;
  static const double _minWidth = 440.0;
  static const double _maxWidth = 800.0;
  static const double _minHeight = 440.0;
  static const double _maxHeight = 700.0;

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty ||
        _codeController.text.trim().isEmpty)
      return;

    setState(() => _isLoading = true);
    final success = await ref
        .read(academicControllerProvider.notifier)
        .createCourse(
          title: _titleController.text,
          code: _codeController.text,
          description: _descriptionController.text,
          category: _category,
          order: int.tryParse(_orderController.text) ?? 0,
        );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        'New Academic Course',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Course Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _codeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Code (e.g. AP MICRO)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _category,
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'AP',
                                      child: Text('AP'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'General',
                                      child: Text('General'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Advisory',
                                      child: Text('Advisory'),
                                    ),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _category = v!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Create Course'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildResizeHandle(),
          ],
        ),
      ),
    );
  }

  Widget _buildResizeHandle() {
    return Positioned(
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
        child: const MouseRegion(
          cursor: SystemMouseCursors.resizeDownRight,
          child: SizedBox(
            width: 24,
            height: 24,
            child: Icon(Icons.south_east, size: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
