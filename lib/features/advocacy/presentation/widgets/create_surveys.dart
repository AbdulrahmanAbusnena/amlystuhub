import 'package:amlystuhub/features/advocacy/presentation/state/advocacy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSurveyDialog extends ConsumerStatefulWidget {
  const CreateSurveyDialog({super.key});

  @override
  ConsumerState<CreateSurveyDialog> createState() => _CreateSurveyDialogState();
}

class _CreateSurveyDialogState extends ConsumerState<CreateSurveyDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _urlController;
  late final FocusNode _descriptionFocusNode;

  String _selectedGrade = 'All Grades';
  bool _apOnly = false;
  bool _isLoading = false;

  // Resizable dialog bounds
  double _dialogWidth = 580.0;
  double _dialogHeight = 620.0;

  static const double _minWidth = 450.0;
  static const double _maxWidth = 900.0;
  static const double _minHeight = 480.0;
  static const double _maxHeight = 800.0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _urlController = TextEditingController();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _applySelectionFormat(String prefix, String suffix) {
    final text = _descriptionController.text;
    final selection = _descriptionController.selection;

    if (!selection.isValid) {
      _descriptionController.text = '$text$prefix$suffix';
      return;
    }

    if (selection.isCollapsed) {
      final pos = selection.start;
      final newText = text.replaceRange(pos, pos, '$prefix$suffix');
      _descriptionController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: pos + prefix.length),
      );
    } else {
      final start = selection.start;
      final end = selection.end;
      final selectedText = text.substring(start, end);
      final newText = text.replaceRange(
        start,
        end,
        '$prefix$selectedText$suffix',
      );
      _descriptionController.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: start + prefix.length,
          extentOffset: start + prefix.length + selectedText.length,
        ),
      );
    }
    _descriptionFocusNode.requestFocus();
  }

  void _applyLinePrefix(String prefix) {
    final text = _descriptionController.text;
    final selection = _descriptionController.selection;
    final cursorOffset = selection.isValid ? selection.start : text.length;

    final lineStart = text.lastIndexOf('\n', cursorOffset - 1) + 1;
    final newText = text.replaceRange(lineStart, lineStart, prefix);

    _descriptionController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorOffset + prefix.length),
    );
    _descriptionFocusNode.requestFocus();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || description.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid URL starting with http:// or https://'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref
        .read(surveyManagementControllerProvider.notifier)
        .publishSurvey(
          title: title,
          description: description,
          googleFormUrl: url,
          targetGrade: _selectedGrade,
          apOnly: _apOnly,
        );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Survey created successfully.')),
        );
      }
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
                      SelectableText(
                        'Create New Survey',
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
                            controller: _titleController,
                            enableInteractiveSelection: true,
                            decoration: const InputDecoration(
                              labelText: 'Survey Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(7),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildFormatButton(
                                        icon: Icons.format_bold,
                                        tooltip: 'Bold',
                                        onPressed: () =>
                                            _applySelectionFormat('**', '**'),
                                      ),
                                      _buildFormatButton(
                                        icon: Icons.format_italic,
                                        tooltip: 'Italic',
                                        onPressed: () =>
                                            _applySelectionFormat('*', '*'),
                                      ),
                                      _buildFormatButton(
                                        icon: Icons.format_list_bulleted,
                                        tooltip: 'Bullet List',
                                        onPressed: () => _applyLinePrefix('- '),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    controller: _descriptionController,
                                    focusNode: _descriptionFocusNode,
                                    maxLines: 5,
                                    enableInteractiveSelection: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      hintText: 'Write survey description...',
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _urlController,
                            enableInteractiveSelection: true,
                            decoration: const InputDecoration(
                              labelText: 'Google Form Link',
                              hintText: 'https://forms.google.com/...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedGrade,
                            decoration: const InputDecoration(
                              labelText: 'Target Grade',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'All Grades',
                                child: Text('All Grades'),
                              ),
                              DropdownMenuItem(
                                value: 'Grade 9',
                                child: Text('Grade 9'),
                              ),
                              DropdownMenuItem(
                                value: 'Grade 10',
                                child: Text('Grade 10'),
                              ),
                              DropdownMenuItem(
                                value: 'Grade 11',
                                child: Text('Grade 11'),
                              ),
                              DropdownMenuItem(
                                value: 'Grade 12',
                                child: Text('Grade 12'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedGrade = val);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('AP Students Only'),
                            value: _apOnly,
                            onChanged: (val) =>
                                setState(() => _apOnly = val ?? false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Publish'),
                        ),
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
                  if (!mounted) return;
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

  Widget _buildFormatButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: IconButton(
        icon: Icon(icon, size: 18),
        tooltip: tooltip,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
      ),
    );
  }
}
