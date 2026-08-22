import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_providers.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddResourceDialog extends ConsumerStatefulWidget {
  final String courseId;
  final String? defaultUnitId; // If opened from a unit context

  const AddResourceDialog({
    super.key,
    required this.courseId,
    this.defaultUnitId,
  });

  @override
  ConsumerState<AddResourceDialog> createState() => _AddResourceDialogState();
}

class _AddResourceDialogState extends ConsumerState<AddResourceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _tagController = TextEditingController();

  ResourceType _type = ResourceType.link;
  late bool _isCourseWide;
  String? _selectedUnitId;

  @override
  void initState() {
    super.initState();
    _isCourseWide = widget.defaultUnitId == null;
    _selectedUnitId = widget.defaultUnitId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(academicControllerProvider.notifier)
        .createResource(
          courseId: widget.courseId,
          unitId: _isCourseWide ? null : _selectedUnitId,
          title: _titleController.text,
          url: _urlController.text,
          type: _type,
          tag: _tagController.text,
        );

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(academicControllerProvider);
    final unitsAsync = ref.watch(unitsStreamProvider(widget.courseId));
    final isLoading = state.status == AcademicStatus.loading;

    return AlertDialog(
      title: const Text('Add Resource'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.status == AcademicStatus.error &&
                  state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              // Placement Selector
              SwitchListTile(
                title: const Text('Course-Wide / Exam Prep'),
                subtitle: const Text('Off = Attach to specific unit'),
                value: _isCourseWide,
                onChanged: (val) {
                  setState(() => _isCourseWide = val);
                },
              ),
              if (!_isCourseWide)
                unitsAsync.when(
                  data: (units) {
                    if (units.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'No units available. Create a unit first.',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      );
                    }
                    _selectedUnitId ??= units.first.id;

                    return DropdownButtonFormField<String>(
                      value: _selectedUnitId,
                      decoration: const InputDecoration(
                        labelText: 'Target Unit',
                      ),
                      items: units
                          .map(
                            (u) => DropdownMenuItem(
                              value: u.id,
                              child: Text('Unit ${u.unitNumber}: ${u.title}'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedUnitId = val),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Failed to load units'),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Resource Title',
                  hintText: 'e.g. FRQ Scoring Guide or Unit 1 Notes',
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL / Link',
                  hintText: 'https://...',
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ResourceType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Resource Type'),
                items: ResourceType.values
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _type = val);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tagController,
                decoration: const InputDecoration(
                  labelText: 'Tag / Label (Optional)',
                  hintText: 'e.g. Exam Prep, Cheat Sheet, Video',
                ),
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
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Resource'),
        ),
      ],
    );
  }
}
