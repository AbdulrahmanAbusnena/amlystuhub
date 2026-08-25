import 'package:amlystuhub/features/advocacy/presentation/state/advocacy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSurveyDialog extends ConsumerStatefulWidget {
  const CreateSurveyDialog({super.key});

  @override
  ConsumerState<CreateSurveyDialog> createState() => _CreateSurveyDialogState();
}

class _CreateSurveyDialogState extends ConsumerState<CreateSurveyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  String _targetGrade = 'All';
  bool _apOnly = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(surveyManagementControllerProvider.notifier);

    final success = await controller.publishSurvey(
      title: _titleController.text,
      description: _descriptionController.text,
      googleFormUrl: _urlController.text,
      targetGrade: _targetGrade,
      apOnly: _apOnly,
    );

    if (mounted && success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey published successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyManagementControllerProvider);

    return AlertDialog(
      title: const Text('Create New Google Form Survey'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Survey Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter a title.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Short Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'Google Form URL',
                    border: OutlineInputBorder(),
                    hintText: 'https://forms.gle/...',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter the form link.';
                    }
                    if (!val.startsWith('http')) {
                      return 'Enter a valid URL (starting with http:// or https://)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _targetGrade,
                  decoration: const InputDecoration(
                    labelText: 'Target Grade',
                    border: OutlineInputBorder(),
                  ),
                  items: ['All', '9', '10', '11', '12'].map((grade) {
                    return DropdownMenuItem(
                      value: grade,
                      child: Text(
                        grade == 'All' ? 'All Grades' : 'Grade $grade',
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _targetGrade = val);
                  },
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('AP-Only Survey'),
                  subtitle: const Text(
                    'Restrict survey visibility to AP students',
                  ),
                  value: _apOnly,
                  onChanged: (val) => setState(() => _apOnly = val ?? false),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: state.isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: state.isLoading ? null : _submit,
          child: state.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Publish'),
        ),
      ],
    );
  }
}
