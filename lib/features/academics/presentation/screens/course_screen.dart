import 'package:amlystuhub/features/academics/domain/models/academic_models.dart';
import 'package:amlystuhub/features/academics/presentation/state/academic_providers.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/add_course.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/add_resource.dart';
import 'package:amlystuhub/features/academics/presentation/widgets/add_unit.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CourseDetailScreen extends ConsumerWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final userAsync = ref.watch(currentUserModelProvider);

    final isLeadership = userAsync.value?.role.canPublishAnnouncements ?? false;

    final generalResourcesAsync = ref.watch(
      generalResourcesStreamProvider(course.id),
    );

    final unitsAsync = ref.watch(unitsStreamProvider(course.id));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _CourseNavigationBar(course: course),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth >= 1100
                      ? 40.0
                      : constraints.maxWidth >= 700
                      ? 28.0
                      : 18.0;

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      34,
                      horizontalPadding,
                      70,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CourseHero(
                              course: course,
                              unitCount: unitsAsync.value?.length ?? 0,
                              resourceCount:
                                  generalResourcesAsync.value?.length ?? 0,
                            ),

                            const SizedBox(height: 42),

                            // ───────────────────────────────────────────────
                            // COURSE-WIDE RESOURCES
                            // ───────────────────────────────────────────────
                            _ContentSectionHeader(
                              title: 'Course Resources',
                              subtitle:
                                  'Exam preparation, study guides, references, and other course-wide materials.',
                              action: isLeadership
                                  ? TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AddResourceDialog(
                                            courseId: course.id,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Add resource'),
                                    )
                                  : null,
                            ),

                            const SizedBox(height: 14),

                            generalResourcesAsync.when(
                              loading: () => const _LoadingLine(),
                              error: (error, _) => _InlineError(
                                message:
                                    'Unable to load course resources: $error',
                              ),
                              data: (resources) {
                                if (resources.isEmpty) {
                                  return const _EmptyResourceState(
                                    message:
                                        'No course-wide resources have been added yet.',
                                  );
                                }

                                return _ResourcePanel(resources: resources);
                              },
                            ),

                            const SizedBox(height: 46),

                            // ───────────────────────────────────────────────
                            // UNITS
                            // ───────────────────────────────────────────────
                            _ContentSectionHeader(
                              title: 'Course Units',
                              subtitle:
                                  'Browse resources organized by curriculum unit.',
                              action: isLeadership
                                  ? TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AddUnitDialog(
                                            courseId: course.id,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Add unit'),
                                    )
                                  : null,
                            ),

                            const SizedBox(height: 14),

                            unitsAsync.when(
                              loading: () => const _LoadingLine(),
                              error: (error, _) => _InlineError(
                                message: 'Unable to load units: $error',
                              ),
                              data: (units) {
                                if (units.isEmpty) {
                                  return const _EmptyResourceState(
                                    message:
                                        'No units have been added to this course yet.',
                                  );
                                }

                                return Column(
                                  children: units.map((unit) {
                                    return _UnitPanel(
                                      courseId: course.id,
                                      unit: unit,
                                      isLeadership: isLeadership,
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// NAVIGATION BAR
// ═══════════════════════════════════════════════════════════════════════════

class _CourseNavigationBar extends StatelessWidget {
  final CourseModel course;

  const _CourseNavigationBar({required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back to Academic Hub',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 7),
                Container(
                  width: 1,
                  height: 22,
                  color: colorScheme.outlineVariant,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    course.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseHero extends StatelessWidget {
  final CourseModel course;
  final int unitCount;
  final int resourceCount;

  const _CourseHero({
    required this.course,
    required this.unitCount,
    required this.resourceCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.school_outlined,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      course.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.4,
                      ),
                    ),
                    if (course.code.trim().isNotEmpty)
                      _CourseBadge(text: course.code),
                    if (course.category.trim().isNotEmpty)
                      _CourseBadge(text: course.category, subtle: true),
                  ],
                ),
                if (course.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 11),
                  Text(
                    course.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    _HeroMetadata(
                      icon: Icons.layers_outlined,
                      label: '$unitCount ${unitCount == 1 ? 'unit' : 'units'}',
                    ),
                    _HeroMetadata(
                      icon: Icons.folder_outlined,
                      label:
                          '$resourceCount ${resourceCount == 1 ? 'resource' : 'resources'}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseBadge extends StatelessWidget {
  final String text;
  final bool subtle;

  const _CourseBadge({required this.text, this.subtle = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: subtle
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: subtle ? colorScheme.onSurfaceVariant : colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _HeroMetadata extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroMetadata({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _ContentSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const _ContentSectionHeader({
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// UNIT PANEL
// ═══════════════════════════════════════════════════════════════════════════

class _UnitPanel extends ConsumerWidget {
  final String courseId;
  final UnitModel unit;
  final bool isLeadership;

  const _UnitPanel({
    required this.courseId,
    required this.unit,
    required this.isLeadership,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final resourcesAsync = ref.watch(
      unitResourcesStreamProvider((courseId: courseId, unitId: unit.id)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.fromLTRB(18, 6, 12, 6),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              Icons.folder_outlined,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          title: Text(
            'Unit ${unit.unitNumber} — ${unit.title}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: unit.description.trim().isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    unit.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              resourcesAsync.when(
                data: (resources) {
                  final count = resources.length;
                  return Text(
                    '$count ${count == 1 ? 'resource' : 'resources'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
                loading: () => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => Text(
                  '0 resources',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (isLeadership)
                PopupMenuButton<String>(
                  tooltip: 'Unit actions',
                  onSelected: (value) {
                    if (value == 'resource') {
                      showDialog(
                        context: context,
                        builder: (_) => AddResourceDialog(
                          courseId: courseId,
                          defaultUnitId: unit.id,
                        ),
                      );
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'resource',
                      child: Text('Add resource'),
                    ),
                  ],
                ),
            ],
          ),
          children: [
            Divider(height: 1, color: colorScheme.outlineVariant),
            const SizedBox(height: 10),
            resourcesAsync.when(
              loading: () => const _LoadingLine(),
              error: (error, _) => _InlineError(
                message: 'Unable to load unit resources: $error',
              ),
              data: (resources) {
                if (resources.isEmpty) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Text(
                        'No resources have been added to this unit yet.',
                      ),
                    ),
                  );
                }

                return _ResourceList(resources: resources);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RESOURCE PANEL
// ═══════════════════════════════════════════════════════════════════════════

class _ResourcePanel extends StatelessWidget {
  final List<ResourceModel> resources;

  const _ResourcePanel({required this.resources});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: _ResourceList(resources: resources),
    );
  }
}

class _ResourceList extends StatelessWidget {
  final List<ResourceModel> resources;

  const _ResourceList({required this.resources});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: resources.map((resource) {
        return _ResourceRow(resource: resource);
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RESOURCE ROW
// ═══════════════════════════════════════════════════════════════════════════

class _ResourceRow extends StatefulWidget {
  final ResourceModel resource;

  const _ResourceRow({required this.resource});

  @override
  State<_ResourceRow> createState() => _ResourceRowState();
}

class _ResourceRowState extends State<_ResourceRow> {
  bool _hovering = false;

  Future<void> _openResource() async {
    final uri = Uri.tryParse(widget.resource.url);

    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resource = widget.resource;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: _openResource,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            color: _hovering
                ? colorScheme.primary.withValues(alpha: 0.055)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              _ResourceIcon(type: resource.type),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if ((resource.tag ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        resource.tag ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 14),
              AnimatedSlide(
                duration: const Duration(milliseconds: 120),
                offset: _hovering ? const Offset(0.15, 0) : Offset.zero,
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: _hovering
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RESOURCE ICON
// ═══════════════════════════════════════════════════════════════════════════

class _ResourceIcon extends StatelessWidget {
  final ResourceType type;

  const _ResourceIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData icon;

    switch (type) {
      case ResourceType.pdf:
        icon = Icons.picture_as_pdf_outlined;
        break;
      case ResourceType.googleDrive:
        icon = Icons.description_outlined;
        break;
      case ResourceType.video:
        icon = Icons.play_circle_outline;
        break;
      case ResourceType.link:
        icon = Icons.link_outlined;
        break;
    }

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyResourceState extends StatelessWidget {
  final String message;

  const _EmptyResourceState({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 19,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LOADING
// ═══════════════════════════════════════════════════════════════════════════

class _LoadingLine extends StatelessWidget {
  const _LoadingLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: LinearProgressIndicator(minHeight: 2),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ERROR
// ═══════════════════════════════════════════════════════════════════════════

class _InlineError extends StatelessWidget {
  final String message;

  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.error),
      ),
    );
  }
}
