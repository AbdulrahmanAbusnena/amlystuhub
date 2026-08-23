import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddResourceDialog extends ConsumerStatefulWidget {
  final String courseId;
  final String? defaultUnitId;

  const AddResourceDialog({
    super.key,
    required this.courseId,
    this.defaultUnitId,
  });

  @override
  ConsumerState<AddResourceDialog> createState() => _AddResourceDialogState();
}

class _AddResourceDialogState extends ConsumerState<AddResourceDialog> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _tagController = TextEditingController();

  ResourceType _type = ResourceType.link;
  late bool _isCourseWide;
  String? _selectedUnitId;
  bool _isLoading = false;

  double _dialogWidth = 560.0;
  double _dialogHeight = 520.0;

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
    if (_titleController.text.trim().isEmpty ||
        _urlController.text.trim().isEmpty)
      return;

    setState(() => _isLoading = true);
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

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(unitsStreamProvider(widget.courseId));

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
                      Text(
                        'Add Resource',
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
                        children: [
                          SwitchListTile(
                            title: const Text('Course-Wide / Exam Prep'),
                            subtitle: const Text(
                              'Toggle off to attach to a specific unit',
                            ),
                            value: _isCourseWide,
                            onChanged: (val) =>
                                setState(() => _isCourseWide = val),
                          ),
                          if (!_isCourseWide)
                            unitsAsync.when(
                              data: (units) {
                                if (units.isEmpty)
                                  return const Text(
                                    'No units available.',
                                    style: TextStyle(color: Colors.red),
                                  );
                                _selectedUnitId ??= units.first.id;
                                return DropdownButtonFormField<String>(
                                  value: _selectedUnitId,
                                  decoration: const InputDecoration(
                                    labelText: 'Target Unit',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: units
                                      .map(
                                        (u) => DropdownMenuItem(
                                          value: u.id,
                                          child: Text(
                                            'Unit ${u.unitNumber}: ${u.title}',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _selectedUnitId = v),
                                );
                              },
                              loading: () => const LinearProgressIndicator(),
                              error: (_, __) =>
                                  const Text('Error loading units'),
                            ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Resource Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _urlController,
                            decoration: const InputDecoration(
                              labelText: 'URL Link',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<ResourceType>(
                                  value: _type,
                                  decoration: const InputDecoration(
                                    labelText: 'Type',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: ResourceType.values
                                      .map(
                                        (t) => DropdownMenuItem(
                                          value: t,
                                          child: Text(t.name.toUpperCase()),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(() => _type = v!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _tagController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tag (e.g. Cheat Sheet)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
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
                            : const Text('Attach Resource'),
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
                onPanUpdate: (d) => setState(() {
                  _dialogWidth = (_dialogWidth + d.delta.dx).clamp(
                    440.0,
                    800.0,
                  );
                  _dialogHeight = (_dialogHeight + d.delta.dy).clamp(
                    440.0,
                    700.0,
                  );
                }),
                child: const MouseRegion(
                  cursor: SystemMouseCursors.resizeDownRight,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(Icons.south_east, size: 14, color: Colors.grey),
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
