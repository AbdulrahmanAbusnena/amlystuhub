import 'package:flutter/material.dart';
import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';

class AcademicSubjectDialog extends StatefulWidget {
  final AcademicSubjectModel? subject;
  final ProgramType currentProgram;
  final ValueChanged<AcademicSubjectModel> onSave;

  const AcademicSubjectDialog({
    super.key,
    this.subject,
    required this.currentProgram,
    required this.onSave,
  });

  @override
  State<AcademicSubjectDialog> createState() => _AcademicSubjectDialogState();
}

class _AcademicSubjectDialogState extends State<AcademicSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  late TextEditingController _driveUrlController;
  late TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.subject?.code ?? '');
    _titleController = TextEditingController(text: widget.subject?.title ?? '');
    _descController = TextEditingController(
      text: widget.subject?.description ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.subject?.category ?? 'General',
    );
    _driveUrlController = TextEditingController(
      text: widget.subject?.masterDriveUrl ?? '',
    );
    _colorController = TextEditingController(
      text: widget.subject?.colorHex ?? '#1E88E5',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _driveUrlController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subject != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Subject' : 'Add Subject'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Subject Code (e.g. AP-MICRO)',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (e.g. AP Microeconomics)',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (e.g. Social Sciences)',
                ),
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextFormField(
                controller: _driveUrlController,
                decoration: const InputDecoration(
                  labelText: 'Master Drive Link (Optional)',
                ),
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color Hex (e.g. #1E88E5)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newSubject = AcademicSubjectModel(
                id: widget.subject?.id ?? '',
                code: _codeController.text.trim(),
                title: _titleController.text.trim(),
                description: _descController.text.trim(),
                category: _categoryController.text.trim(),
                programType: widget.currentProgram,
                masterDriveUrl: _driveUrlController.text.trim().isEmpty
                    ? null
                    : _driveUrlController.text.trim(),
                colorHex: _colorController.text.trim(),
              );
              widget.onSave(newSubject);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
