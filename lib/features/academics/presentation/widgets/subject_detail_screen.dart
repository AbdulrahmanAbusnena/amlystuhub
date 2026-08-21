import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_controller.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/dialog/academic_resource_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SubjectDetailScreen extends ConsumerStatefulWidget {
  final AcademicSubjectModel subject;
  final bool isStuCoAdmin;

  const SubjectDetailScreen({
    super.key,
    required this.subject,
    this.isStuCoAdmin = false,
  });

  @override
  ConsumerState<SubjectDetailScreen> createState() =>
      _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends ConsumerState<SubjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ResourceCategory> _categories = [
    ResourceCategory.overview,
    ResourceCategory.guides,
    ResourceCategory.practice,
    ResourceCategory.videos,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.blueAccent;
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subjectColor = _parseColor(widget.subject.colorHex as String);
    final resourcesAsync = ref.watch(
      subjectResourcesStreamProvider(widget.subject.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.code),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: subjectColor,
          labelColor: theme.textTheme.bodyLarge?.color,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Guides & Notes'),
            Tab(text: 'Practice & Files'),
            Tab(text: 'Video Lessons'),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: subjectColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.subject.category,
                                style: TextStyle(
                                  color: subjectColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (widget.subject.driveFolderUrl != null &&
                                widget.subject.driveFolderUrl!.isNotEmpty)
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _launchUrl(widget.subject.driveFolderUrl!),
                                icon: const Icon(
                                  Icons.folder_outlined,
                                  size: 16,
                                ),
                                label: const Text('Drive Folder'),
                                style: OutlinedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.subject.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.subject.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            widget.subject.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: resourcesAsync.when(
          data: (resources) {
            return TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                final categoryResources = resources
                    .where((r) => r.tabCategory == category)
                    .toList();

                if (categoryResources.isEmpty) {
                  return Center(
                    child: Text(
                      'No resources available in this section.',
                      style: TextStyle(color: colorScheme.outline),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: categoryResources.length,
                  itemBuilder: (context, index) {
                    final resource = categoryResources[index];
                    return _buildResourceTile(context, ref, resource);
                  },
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) =>
              Center(child: Text('Error loading resources: $err')),
        ),
      ),
      floatingActionButton: widget.isStuCoAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _openAddResourceDialog(context, ref),
              icon: const Icon(Icons.add_link),
              label: const Text('Add Resource'),
            )
          : null,
    );
  }

  Widget _buildResourceTile(
    BuildContext context,
    WidgetRef ref,
    AcademicResourceModel resource,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData getIcon() {
      switch (resource.resourceType) {
        case ResourceType.pdf:
          return Icons.picture_as_pdf_outlined;
        case ResourceType.driveFolder:
          return Icons.folder_shared_outlined;
        case ResourceType.youtube:
          return Icons.play_circle_outline;
        case ResourceType.externalLink:
          return Icons.language_outlined;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            getIcon(),
            color: colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          resource.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resource.description.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                resource.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
            if (resource.unitTag != null && resource.unitTag!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  resource.unitTag!,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.open_in_new, size: 18),
              onPressed: () => _launchUrl(resource.url),
            ),
            if (widget.isStuCoAdmin)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                onSelected: (val) {
                  if (val == 'edit')
                    _openEditResourceDialog(context, ref, resource);
                  if (val == 'delete')
                    _confirmDeleteResource(context, ref, resource);
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _openAddResourceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AcademicResourceDialog(
        subjectId: widget.subject.id,
        initialCategory: _categories[_tabController.index],
        onSave: (resource) async {
          await ref
              .read(academicControllerProvider.notifier)
              .addResource(resource);
        },
      ),
    );
  }

  void _openEditResourceDialog(
    BuildContext context,
    WidgetRef ref,
    AcademicResourceModel resource,
  ) {
    showDialog(
      context: context,
      builder: (_) => AcademicResourceDialog(
        subjectId: widget.subject.id,
        resource: resource,
        initialCategory: resource.tabCategory,
        onSave: (updated) async {
          await ref
              .read(academicControllerProvider.notifier)
              .updateResource(resource.id, updated);
        },
      ),
    );
  }

  void _confirmDeleteResource(
    BuildContext context,
    WidgetRef ref,
    AcademicResourceModel resource,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Resource'),
        content: Text('Delete "${resource.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(academicControllerProvider.notifier)
                  .deleteResource(resource.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
