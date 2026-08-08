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
    final user = userAsync.value;

    if (user == null) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Determine allowed categories using our type-safe UserRole enum getter
    final allowedCategories = user.role.allowedAnnouncementCategories;

    // Ensure selected category stays valid relative to role permissions
    if (!allowedCategories.contains(_selectedCategory) &&
        allowedCategories.isNotEmpty) {
      _selectedCategory = allowedCategories.first;
    }

    final state = ref.watch(announcementControllerProvider);
    final isLoading = state.status == AnnouncementStatus.loading;

    return AlertDialog(
      title: const Text('New Announcement'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error Display
              if (state.status == AnnouncementStatus.error &&
                  state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              // Title Field
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

              // Content Field
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

              // Category Picker
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

              // Target Grades Chips
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
              const SizedBox(height: 12),

              // AP Only Switch
              SwitchListTile(
                title: const Text(
                  'AP Students Only',
                  style: TextStyle(fontSize: 14),
                ),
                contentPadding: EdgeInsets.zero,
                value: _apOnly,
                onChanged: (val) => setState(() => _apOnly = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? _submitForm : () => _submitForm(),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Publish'),
        ),
      ],
    );
  }
}
