import 'package:amlystuhub/features/academics/domain/models/academic_course_model.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCourseDialog extends ConsumerStatefulWidget {
  const AddCourseDialog({super.key});

  @override
  ConsumerState<AddCourseDialog> createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends ConsumerState<AddCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _codeController = TextEditingController();
  final _descController = TextEditingController();
  final _driveUrlController = TextEditingController();
  bool _isAp = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _descController.dispose();
    _driveUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final newCourse = AcademicCourseModel(
      id: '',
      code: _codeController.text.trim().toUpperCase(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      mainDriveFolderUrl: _driveUrlController.text.trim(),
      isAp: _isAp,
    );

    await ref
        .read(academicsControllerProvider.notifier)
        .createCourse(newCourse, title: _titleController.text.trim());

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Academic Course'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Course Title (e.g., AP Computer Science A)',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Course Code (e.g., AP-CSA)',
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Course code is required'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _driveUrlController,
                decoration: const InputDecoration(
                  labelText: 'Main Google Drive URL',
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('AP Course'),
                value: _isAp,
                onChanged: (val) => setState(() => _isAp = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
