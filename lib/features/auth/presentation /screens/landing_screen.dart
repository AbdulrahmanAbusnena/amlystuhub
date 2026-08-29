import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amlystuhub/core/widgets/primary_button.dart';
import 'package:amlystuhub/core/widgets/app_header.dart';

class TeamMember {
  final String name;
  final String role;
  final String imagePath;

  const TeamMember({
    required this.name,
    required this.role,
    required this.imagePath,
  });
}

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  static const List<TeamMember> _team = [
    TeamMember(
      name: 'Sama Elbuzidi',
      role: 'President',
      imagePath: 'assets/images/team/sama.png',
    ),
    TeamMember(
      name: 'Farah Elghabar',
      role: 'Vice President',
      imagePath: 'assets/images/team/farah.png',
    ),
    TeamMember(
      name: 'Abdulrahman Abusnena',
      role: 'Tech Lead & Academics',
      imagePath: 'assets/images/team/abdulrahman.png',
    ),
    TeamMember(
      name: 'Lena Abughila',
      role: 'Advocacy Lead',
      imagePath: 'assets/images/team/lena.png',
    ),
    TeamMember(
      name: 'Rama',
      role: 'Academics Lead',
      imagePath: 'assets/images/team/rama.png',
    ),
    TeamMember(
      name: 'Omar Swehli',
      role: 'Activities Lead',
      imagePath: 'assets/images/team/omar.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SelectionArea(
          child: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeroSection(context),
                        _buildInteractiveStatsSection(context),
                        _buildTeamSection(context),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ambient Background Glow Effects
        Positioned(
          top: -40,
          left: -40,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: -50,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.tertiary.withValues(alpha: 0.1),
            ),
          ),
        ),

        // Hero Content Layout
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 72.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Pill Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "AMLY's Student Council Hub",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Main Display Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2.0,
                        fontSize: 60,
                        height: 1.1,
                        color: colorScheme.onSurface,
                      ),
                      children: [
                        const TextSpan(text: 'Empowering Student\n'),
                        TextSpan(
                          text: 'Leadership & Academics.',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Subtitle Narrative
                  Container(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Text(
                      'AMLY StuHub is the central nervous system for campus initiatives, AP course materials, student council advocacy, and event management.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: 0.75,
                        ),
                        height: 1.6,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Primary Actions
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      PrimaryButton(
                        label: 'GET STARTED',
                        onPressed: () => context.go('/signup'),
                        width: 210,
                        height: 54,
                      ),
                      OutlinedButton(
                        onPressed: () => context.go('/login'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(170, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'LOG IN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),

                  // Hero Visual Interactive Dashboard Snippet Card
                  _buildHeroPreviewCard(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroPreviewCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 650;
          return Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetricItem(
                context,
                label: 'AP & Academic Modules',
                value: 'Active',
                icon: Icons.auto_stories_outlined,
              ),
              if (isCompact)
                const Divider(height: 32)
              else
                _buildVerticalDivider(context),
              _buildMetricItem(
                context,
                label: 'Advocacy Portal',
                value: 'Open Proposals',
                icon: Icons.record_voice_over_outlined,
              ),
              if (isCompact)
                const Divider(height: 32)
              else
                _buildVerticalDivider(context),
              _buildMetricItem(
                context,
                label: 'Student Council',
                value: '2026-2027 Term',
                icon: Icons.groups_outlined,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(
                  alpha: 0.65,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }

  Widget _buildInteractiveStatsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatTile(
                    context,
                    'Academics',
                    'AP & Course Resources',
                    Icons.school_outlined,
                  ),
                  if (isMobile) const SizedBox(height: 24),
                  _buildStatTile(
                    context,
                    'Advocacy',
                    'Student Voice & Proposals',
                    Icons.campaign_outlined,
                  ),
                  if (isMobile) const SizedBox(height: 24),
                  _buildStatTile(
                    context,
                    'Activities',
                    'Events & Campus Life',
                    Icons.event_available_outlined,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 28),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Text(
                'MEET THE TEAM',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Leadership & Student Council',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 800
                      ? 3
                      : (constraints.maxWidth > 500 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: _team.length,
                    itemBuilder: (context, index) {
                      return _InteractiveTeamCard(member: _team[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.center,
            children: [
              Text(
                '© 2026 AMLYSTUHUB',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isMobile) const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'Tech Support: abdulrahmanabusnena01@gmail.com',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                  Text(
                    'Tel: 091609518',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InteractiveTeamCard extends StatefulWidget {
  final TeamMember member;

  const _InteractiveTeamCard({required this.member});

  @override
  State<_InteractiveTeamCard> createState() => _InteractiveTeamCardState();
}

class _InteractiveTeamCardState extends State<_InteractiveTeamCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -6, 0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? colorScheme.primary.withValues(alpha: 0.6)
                : colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: colorScheme.primaryContainer,
              foregroundImage: AssetImage(widget.member.imagePath),
              onForegroundImageError: (_, __) {},
              child: Text(
                widget.member.name[0],
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.member.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.member.role,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
