import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/dashboard/domain/models/ui_vibes.dart';
import 'package:amlystuhub/features/dashboard/presentation/providers/vibe_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTopNavBar extends ConsumerWidget implements PreferredSizeWidget {
  final Function(int)? onNavigateToTab;

  const CustomTopNavBar({super.key, this.onNavigateToTab});

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userAsync = ref.watch(currentUserModelProvider);
    final user = userAsync.value;

    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Title
          Row(
            children: [
              RichText(
                text: TextSpan(
                  style: theme.textTheme.titleLarge?.copyWith(
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'AMLY ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: 'StuHub',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              if (user != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    user.role.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Right Actions: Vibe Switcher, Notifications, User Menu
          Row(
            children: [
              // Active UI Vibe Switcher Component
              _buildVibeSelector(context, ref),
              const SizedBox(width: 4),

              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Notifications',
                onPressed: () {},
              ),
              const SizedBox(width: 8),

              // Profile / Account Dropdown
              PopupMenuButton<String>(
                offset: const Offset(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          (user?.name.isNotEmpty == true)
                              ? user!.name[0].toUpperCase()
                              : 'S',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (MediaQuery.of(context).size.width >= 600) ...[
                        Text(
                          user?.name ?? 'Student',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 20),
                      ],
                    ],
                  ),
                ),
                onSelected: (value) {
                  if (value == 'profile') {
                    onNavigateToTab?.call(4);
                  } else if (value == 'logout') {
                    ref.read(authServiceProvider).signOut();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: const [
                        Icon(Icons.person_outline, size: 18),
                        SizedBox(width: 12),
                        Text('Profile Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 18, color: colorScheme.error),
                        const SizedBox(width: 12),
                        Text(
                          'Log Out',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVibeSelector(BuildContext context, WidgetRef ref) {
    final currentVibe = ref.watch(uiVibeProvider);

    return PopupMenuButton<UiVibe>(
      icon: const Icon(Icons.palette_outlined),
      tooltip: 'Select UI Vibe',
      initialValue: currentVibe,
      onSelected: (UiVibe newVibe) {
        ref.read(uiVibeProvider.notifier).setVibe(newVibe);
      },
      itemBuilder: (context) => UiVibe.values.map((vibe) {
        return PopupMenuItem<UiVibe>(
          value: vibe,
          child: Row(
            children: [
              Icon(
                currentVibe == vibe
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(vibe.displayName),
            ],
          ),
        );
      }).toList(),
    );
  }
}
