import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_themes.dart';
import 'theme_provider.dart';

class ThemeSelectorDialog extends ConsumerWidget {
  const ThemeSelectorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentState = ref.watch(themeNotifierProvider);
    final notifier = ref.read(themeNotifierProvider.notifier);

    return AlertDialog(
      title: const Text('Appearance & Customization'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color Palette',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildThemeChip(
                  context,
                  label: 'Light Standard',
                  selected: currentState.themeKey == AppThemeKey.lightStandard,
                  onTap: () => notifier.setTheme(AppThemeKey.lightStandard),
                ),
                _buildThemeChip(
                  context,
                  label: 'Dark Slate',
                  selected: currentState.themeKey == AppThemeKey.darkSlate,
                  onTap: () => notifier.setTheme(AppThemeKey.darkSlate),
                ),
                _buildThemeChip(
                  context,
                  label: 'Midnight Blue',
                  selected: currentState.themeKey == AppThemeKey.midnightBlue,
                  onTap: () => notifier.setTheme(AppThemeKey.midnightBlue),
                ),
                _buildThemeChip(
                  context,
                  label: 'Soft Pink',
                  selected: currentState.themeKey == AppThemeKey.softPink,
                  onTap: () => notifier.setTheme(AppThemeKey.softPink),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Typography Style',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Standard (Clean)'),
                  selected: currentState.fontFamily == AppFontFamily.standard,
                  onSelected: (_) => notifier.setFont(AppFontFamily.standard),
                ),
                ChoiceChip(
                  label: const Text('Handwriting (Original)'),
                  selected:
                      currentState.fontFamily == AppFontFamily.handwriting,
                  onSelected: (_) =>
                      notifier.setFont(AppFontFamily.handwriting),
                ),
                ChoiceChip(
                  label: const Text('Monospace (Technical)'),
                  selected: currentState.fontFamily == AppFontFamily.monospace,
                  onSelected: (_) => notifier.setFont(AppFontFamily.monospace),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildThemeChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
