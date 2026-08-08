import 'package:amlystuhub/features/announcements/presentation/state/announcement_state.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/announcement_controller.dart';

class CreateAnnouncementDialog extends ConsumerStatefulWidget {
  const CreateAnnouncementDialog({super.key});

  @override
  ConsumerState<CreateAnnouncementDialog> createState() =>
      _CreateAnnouncementDialogState();
}

class _CreateAnnouncementDialogState
    extends ConsumerState<CreateAnnouncementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String _selectedCategory = 'General';
  final List<int> _selectedGrades = [];
  bool _apOnly = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _toggleGrade(int grade) {
    setState(() {
      if (_selectedGrades.contains(grade)) {
        _selectedGrades.remove(grade);
      } else {
        _selectedGrades.add(grade);
      }
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserModelProvider).value;
    if (user == null) return;

    final success = await ref
        .read(announcementControllerProvider.notifier)
        .createAnnouncement(
          title: _titleController.text,
          content: _contentController.text,
          category: _selectedCategory,
          targetGrades: _selectedGrades,
          apOnly: _apOnly,
          authorId: user.uid,
          authorName: user.name,
          authorRole: user.role,
        );

    if (mounted && success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement published successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserModelProvider);

    return userAsync.when(
      loading: () => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (err, stack) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to load user profile: $err'),
      ),
      data: (user) {
        if (user == null) {
          return const AlertDialog(
            title: Text('Not Authenticated'),
            content: Text('Please log in to create an announcement.'),
          );
        }

        final allowedCategories = user.role.allowedAnnouncementCategories;

        if (!allowedCategories.contains(_selectedCategory) &&
            allowedCategories.isNotEmpty) {
          _selectedCategory = allowedCategories.first;
        }

        final state = ref.watch(announcementControllerProvider);

        return AlertDialog(
          title: const Text('New Announcement'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status == AnnouncementStatus.error &&
                      state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g., StuCo Bake Sale Postponed',
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Title is required'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Body Content',
                      alignLabelWithHint: true,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Content is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: allowedCategories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Target Grades (Select none for all grades)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [9, 10, 11, 12].map((grade) {
                      final isSelected = _selectedGrades.contains(grade);
                      return FilterChip(
                        label: Text('Grade $grade'),
                        selected: isSelected,
                        onSelected: (_) => _toggleGrade(grade),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: state.status == AnnouncementStatus.loading
                  ? null
                  : _submitForm,
              child: state.status == AnnouncementStatus.loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Post'),
            ),
          ],
        );
      },
    );
  }
}
