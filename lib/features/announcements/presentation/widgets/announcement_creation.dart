import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:amlystuhub/features/announcements/presentation/state/announcement_controller.dart';

class CreateAnnouncementDialog extends ConsumerStatefulWidget {
  final AnnouncementModel? announcementToEdit;

  const CreateAnnouncementDialog({super.key, this.announcementToEdit});

  @override
  ConsumerState<CreateAnnouncementDialog> createState() =>
      _CreateAnnouncementDialogState();
}

class _CreateAnnouncementDialogState
    extends ConsumerState<CreateAnnouncementDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late String _selectedCategory;
  late List<int> _selectedGrades;
  bool _isLoading = false;

  // Window sizing constraints
  double _dialogWidth = 550.0;
  double _dialogHeight = 620.0;

  static const double _minWidth = 450.0;
  static const double _maxWidth = 900.0;
  static const double _minHeight = 500.0;
  static const double _maxHeight = 800.0;

  final List<int> _availableGrades = [9, 10, 11, 12];
  final List<String> _categories = [
    'General',
    'StuCo',
    'Exam',
    'AP',
    'Emergency',
  ];

  bool get isEditing => widget.announcementToEdit != null;

  @override
  void initState() {
    super.initState();
    final announcement = widget.announcementToEdit;

    _titleController = TextEditingController(text: announcement?.title ?? '');
    _contentController = TextEditingController(
      text: announcement?.content ?? '',
    );
    _selectedCategory = announcement?.category ?? 'General';
    _selectedGrades = List<int>.from(announcement?.targetGrades ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Organic Markdown formatting insertion
  void _applyInlineFormat(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (!selection.isValid || selection.isCollapsed) {
      // No text selected: insert tags and put cursor right in the middle
      final start = selection.isValid ? selection.start : text.length;
      final newText = text.replaceRange(start, start, '$prefix$suffix');
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + prefix.length),
      );
      return;
    }

    // Wrap highlighted text
    final start = selection.start;
    final end = selection.end;
    final selectedText = text.substring(start, end);

    final newText = text.replaceRange(
      start,
      end,
      '$prefix$selectedText$suffix',
    );
    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: start + prefix.length,
        extentOffset: start + prefix.length + selectedText.length,
      ),
    );
  }

  void _applyLinePrefix(String prefix) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final cursorOffset = selection.isValid ? selection.start : text.length;

    // Find start of current line
    final lineStart = text.lastIndexOf('\n', cursorOffset - 1) + 1;

    final newText = text.replaceRange(lineStart, lineStart, prefix);
    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorOffset + prefix.length),
    );
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserModelProvider).value;
    if (user == null) return;

    setState(() => _isLoading = true);

    final controller = ref.read(announcementControllerProvider.notifier);
    final isApCategory = _selectedCategory == 'AP';
    bool success;

    if (isEditing) {
      success = await controller.editAnnouncement(
        announcementId: widget.announcementToEdit!.id,
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
        targetGrades: _selectedGrades,
        apOnly: isApCategory,
      );
    } else {
      success = await controller.createAnnouncement(
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
        targetGrades: _selectedGrades,
        apOnly: isApCategory,
        authorId: user.uid,
        authorName: user.name,
        authorRole: user.role,
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: _dialogWidth,
        height: _dialogHeight,
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Window Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Edit Announcement' : 'New Announcement',
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
                const Divider(),
                const SizedBox(height: 8),

                // Main Form Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Embedded Format Box
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Content',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    iconSize: 18,
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Bold',
                                    icon: const Icon(Icons.format_bold),
                                    onPressed: () =>
                                        _applyInlineFormat('**', '**'),
                                  ),
                                  IconButton(
                                    iconSize: 18,
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Italics',
                                    icon: const Icon(Icons.format_italic),
                                    onPressed: () =>
                                        _applyInlineFormat('*', '*'),
                                  ),
                                  IconButton(
                                    iconSize: 18,
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Bullet List',
                                    icon: const Icon(
                                      Icons.format_list_bulleted,
                                    ),
                                    onPressed: () => _applyLinePrefix('- '),
                                  ),
                                  IconButton(
                                    iconSize: 18,
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Header',
                                    icon: const Icon(Icons.title),
                                    onPressed: () => _applyLinePrefix('### '),
                                  ),
                                ],
                              ),
                              const Divider(height: 1, thickness: 1),
                              TextField(
                                controller: _contentController,
                                maxLines: 6,
                                decoration: const InputDecoration(
                                  hintText: 'Type announcement details...',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(top: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: _categories.contains(_selectedCategory)
                              ? _selectedCategory
                              : 'General',
                          items: _categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCategory = val);
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Target Grade Levels (Leave empty for All Grades):',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 8,
                          children: _availableGrades.map((grade) {
                            final isSelected = _selectedGrades.contains(grade);
                            return FilterChip(
                              label: Text('Grade $grade'),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedGrades.add(grade);
                                  } else {
                                    _selectedGrades.remove(grade);
                                  }
                                  _selectedGrades.sort();
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Dialog Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEditing ? 'Save Changes' : 'Post'),
                    ),
                  ],
                ),
              ],
            ),

            // Resizable Window Handle (Bottom Right)
            Positioned(
              right: -8,
              bottom: -8,
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
                  cursor: SystemMouseCursors.resizeUpLeftDownRight,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    color: Colors.transparent,
                    child: const Icon(
                      Icons.south_east,
                      size: 16,
                      color: Colors.grey,
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
