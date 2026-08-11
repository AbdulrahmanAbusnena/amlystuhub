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
  late final TextEditingController _linkInputController;
  late final TextEditingController _imageInputController;
  late final FocusNode _contentFocusNode;

  late String _selectedCategory;
  late List<int> _selectedGrades;
  late List<String> _linkUrls;
  late List<String> _imageUrls;
  bool _isLoading = false;

  double _dialogWidth = 620.0;
  double _dialogHeight = 700.0;

  static const double _minWidth = 480.0;
  static const double _maxWidth = 950.0;
  static const double _minHeight = 550.0;
  static const double _maxHeight = 850.0;

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
    _linkInputController = TextEditingController();
    _imageInputController = TextEditingController();
    _contentFocusNode = FocusNode();

    _selectedCategory = announcement?.category ?? 'General';
    _selectedGrades = List<int>.from(announcement?.targetGrades ?? []);
    _linkUrls = List<String>.from(announcement?.linkUrls ?? []);
    _imageUrls = List<String>.from(announcement?.imageUrls ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _linkInputController.dispose();
    _imageInputController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _addLink() {
    final val = _linkInputController.text.trim();
    if (val.isNotEmpty && !_linkUrls.contains(val)) {
      setState(() {
        _linkUrls.add(val);
        _linkInputController.clear();
      });
    }
  }

  void _addImage() {
    final val = _imageInputController.text.trim();
    if (val.isNotEmpty && !_imageUrls.contains(val)) {
      setState(() {
        _imageUrls.add(val);
        _imageInputController.clear();
      });
    }
  }

  void _applySelectionFormat(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (!selection.isValid || selection.isCollapsed) {
      final pos = selection.isValid ? selection.start : text.length;
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
        imageUrls: _imageUrls,
        linkUrls: _linkUrls,
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
        imageUrls: _imageUrls,
        linkUrls: _linkUrls,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
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
                              labelText: 'Title',
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
                                      IconButton(
                                        icon: const Icon(
                                          Icons.format_bold,
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            _applySelectionFormat('**', '**'),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.format_italic,
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            _applySelectionFormat('*', '*'),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    controller: _contentController,
                                    focusNode: _contentFocusNode,
                                    maxLines: 5,
                                    enableInteractiveSelection: true,
                                    decoration: const InputDecoration(
                                      hintText: 'Write content details...',
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Links Section
                          Text(
                            'Attach Web Links',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _linkInputController,
                                  decoration: const InputDecoration(
                                    hintText: 'https://...',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filledTonal(
                                icon: const Icon(Icons.add_link),
                                onPressed: _addLink,
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 6,
                            children: _linkUrls
                                .map(
                                  (link) => Chip(
                                    label: Text(
                                      link,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    onDeleted: () =>
                                        setState(() => _linkUrls.remove(link)),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 16),

                          // Images Section
                          Text(
                            'Attach Image URLs',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _imageInputController,
                                  decoration: const InputDecoration(
                                    hintText: 'Image direct URL...',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filledTonal(
                                icon: const Icon(Icons.add_a_photo_outlined),
                                onPressed: _addImage,
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 6,
                            children: _imageUrls
                                .map(
                                  (img) => Chip(
                                    label: Text(
                                      img,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    onDeleted: () =>
                                        setState(() => _imageUrls.remove(img)),
                                  ),
                                )
                                .toList(),
                          ),
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
                              if (val != null)
                                setState(() => _selectedCategory = val);
                            },
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(isEditing ? 'Save Changes' : 'Post'),
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
