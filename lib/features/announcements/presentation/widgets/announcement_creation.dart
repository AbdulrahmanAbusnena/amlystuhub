import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:file_picker/file_picker.dart';
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
  late final FocusNode _contentFocusNode;
  late String _selectedCategory;
  late List<int> _selectedGrades;

  final List<PlatformFile> _selectedFiles = [];
  bool _isLoading = false;

  // Window sizing constraints
  double _dialogWidth = 580.0;
  double _dialogHeight = 640.0;

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
    _contentFocusNode = FocusNode();
    _selectedCategory = announcement?.category ?? 'General';
    _selectedGrades = List<int>.from(announcement?.targetGrades ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  /// Formats selected text smoothly or surrounds the cursor position cleanly
  void _applySelectionFormat(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (!selection.isValid) {
      _contentController.text = '$text$prefix$suffix';
      return;
    }

    if (selection.isCollapsed) {
      final pos = selection.start;
      final newText = text.replaceRange(pos, pos, '$prefix$suffix');
      _contentController.value = TextEditingValue(
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
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: start + prefix.length,
          extentOffset: start + prefix.length + selectedText.length,
        ),
      );
    }
    _contentFocusNode.requestFocus();
  }

  void _applyLinePrefix(String prefix) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final cursorOffset = selection.isValid ? selection.start : text.length;

    final lineStart = text.lastIndexOf('\n', cursorOffset - 1) + 1;
    final newText = text.replaceRange(lineStart, lineStart, prefix);

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorOffset + prefix.length),
    );
    _contentFocusNode.requestFocus();
  }

  Future<void> _pickDeviceFiles({FileType type = FileType.any}) async {
    final result = await FilePicker.pickFiles(type: type, allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
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
                  // Title Bar with Copyable Window Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                        isEditing ? 'Edit Announcement' : 'New Announcement',
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

                  // Main Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _titleController,
                            enableInteractiveSelection: true,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Integrated Text Formatting Box
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Action Bar
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
                                      const VerticalDivider(
                                        width: 12,
                                        indent: 6,
                                        endIndent: 6,
                                      ),
                                      _buildFormatButton(
                                        icon: Icons.image_outlined,
                                        tooltip: 'Attach Image',
                                        onPressed: () => _pickDeviceFiles(
                                          type: FileType.image,
                                        ),
                                      ),
                                      _buildFormatButton(
                                        icon: Icons.attach_file_outlined,
                                        tooltip: 'Attach File',
                                        onPressed: () => _pickDeviceFiles(
                                          type: FileType.any,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                // Content Field with selection enabled
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    controller: _contentController,
                                    focusNode: _contentFocusNode,
                                    maxLines: 6,
                                    enableInteractiveSelection: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      hintText: 'Write content here...',
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (_selectedFiles.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _selectedFiles.map((file) {
                                return Chip(
                                  avatar: Icon(
                                    file.extension == 'jpg' ||
                                            file.extension == 'png'
                                        ? Icons.image
                                        : Icons.insert_drive_file,
                                    size: 16,
                                  ),
                                  label: Text(
                                    file.name,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedFiles.remove(file);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 16),

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

                          SelectableText(
                            'Target Grade Levels (Leave empty for All Grades):',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8,
                            children: _availableGrades.map((grade) {
                              final isSelected = _selectedGrades.contains(
                                grade,
                              );
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

                  // Actions
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
                              : Text(isEditing ? 'Save Changes' : 'Post'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Interactive Resize Handle (Bottom Right)
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
