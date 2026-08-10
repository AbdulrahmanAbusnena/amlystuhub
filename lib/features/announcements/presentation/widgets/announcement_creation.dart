import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amlystuhub/features/announcements/domain/models/announcement_models.dart';
import 'package:amlystuhub/features/announcements/presentation/state/announcement_controller.dart';

class CreateAnnouncementDialog extends ConsumerStatefulWidget {
  final AnnouncementModel? announcementToEdit;

  const CreateAnnouncementDialog({
    super.key,
    this.announcementToEdit,
  });

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

    _titleController =
        TextEditingController(text: announcement?.title ?? '');
    _contentController =
        TextEditingController(text: announcement?.content ?? '');
    _selectedCategory = announcement?.category ?? 'General';
    _selectedGrades = List<int>.from(announcement?.targetGrades ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
    return AlertDialog(
      title: Text(isEditing ? 'Edit Announcement' : 'New Announcement'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _categories.contains(_selectedCategory)
                  ? _selectedCategory
                  : 'General',
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Target Grade Levels (Leave empty for All Grades):',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
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
    );
  }
} 