import 'package:flutter/material.dart';

class ReminderBanner extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onTap;

  const ReminderBanner({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.campaign_outlined,
    this.onTap,
  });

  @override
  State<ReminderBanner> createState() => _ReminderBannerState();
}

class _ReminderBannerState extends State<ReminderBanner> {
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
