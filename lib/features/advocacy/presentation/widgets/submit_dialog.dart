import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/advocacy_models.dart';
import '../state/advocacy_controller.dart';

class SubmitTicketDialog extends ConsumerStatefulWidget {
  final TicketModel? ticketToEdit;

  const SubmitTicketDialog({super.key, this.ticketToEdit});

  @override
  ConsumerState<SubmitTicketDialog> createState() => _SubmitTicketDialogState();
}

class _SubmitTicketDialogState extends ConsumerState<SubmitTicketDialog> {
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;
  late final FocusNode _descriptionFocusNode;

  late TicketCategory _selectedCategory;
  late bool _isDiscreet;
  late bool _apOnly;
  bool _isLoading = false;

  // Window sizing constraints matching Announcement dialog
  double _dialogWidth = 580.0;
  double _dialogHeight = 640.0;

  static const double _minWidth = 450.0;
  static const double _maxWidth = 900.0;
  static const double _minHeight = 500.0;
  static const double _maxHeight = 800.0;

  bool get _isEditing => widget.ticketToEdit != null;

  @override
  void initState() {
    super.initState();
    final edit = widget.ticketToEdit;
    _subjectController = TextEditingController(text: edit?.subject ?? '');
    _descriptionController = TextEditingController(
      text: edit?.description ?? '',
    );
    _descriptionFocusNode = FocusNode();
    _selectedCategory = edit?.category ?? TicketCategory.generalAdvice;
    _isDiscreet = edit?.isDiscreet ?? false;
    _apOnly = edit?.apOnly ?? false;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
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

  Future<void> _handleSubmit() async {
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();

    if (subject.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a subject and description.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final controller = ref.read(ticketSubmissionControllerProvider.notifier);
    final bool success;

    if (_isEditing) {
      final updated = widget.ticketToEdit!.copyWith(
        subject: subject,
        description: description,
        category: _selectedCategory,
        isDiscreet: _isDiscreet,
        apOnly: _apOnly,
      );
      success = await controller.editTicket(updated);
    } else {
      success = await controller.submitTicket(
        category: _selectedCategory,
        subject: subject,
        description: description,
        isDiscreet: _isDiscreet,
        apOnly: _apOnly,
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pop(true);
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
                        _isEditing ? 'Edit Ticket' : 'Submit Advocacy Ticket',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => Navigator.of(context).pop(false),
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
                              if (val != null && mounted) {
                                setState(() => _selectedCategory = val);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _subjectController,
                            enableInteractiveSelection: true,
                            decoration: const InputDecoration(
                              labelText: 'Subject',
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
                                      _buildFormatButton(
                                        icon: Icons.title,
                                        tooltip: 'Heading',
                                        onPressed: () =>
                                            _applyLinePrefix('### '),
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
                                    maxLines: 6,
                                    enableInteractiveSelection: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Describe your concern or feedback...',
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Discreet Submission'),
                            subtitle: const Text(
                              'Hide author name from general views',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: _isDiscreet,
                            onChanged: (val) =>
                                setState(() => _isDiscreet = val ?? false),
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('AP-Only Issue'),
                            subtitle: const Text(
                              'Flag for AP curriculum coordinators',
                              style: TextStyle(fontSize: 12),
                            ),
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
                              : () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(_isEditing ? 'Save Changes' : 'Submit'),
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
