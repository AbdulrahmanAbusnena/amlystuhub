import 'package:flutter/material.dart';

class RetroWindowShell extends StatelessWidget {
  final String title;
  final Widget child;

  const RetroWindowShell({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.colorScheme.onSurface, width: 2),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        theme.cardColor, // Pulls your custom header pink/gray
                    border: const Border(
                      bottom: BorderSide(color: Colors.black, width: 2),
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left System Indicator Dots + Title
                      Row(
                        children: [
                          const Text(
                            '🟡 🟢 🔴 ',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      // Right Window Operation Controls
                      Row(
                        children: [
                          _buildHeaderBtn('✕'),
                          const SizedBox(width: 4),
                          _buildHeaderBtn('─'),
                          const SizedBox(width: 4),
                          _buildHeaderBtn('+'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Window Workspace Content
                Padding(padding: const EdgeInsets.all(16.0), child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBtn(String label) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.black,
        ),
      ),
    );
  }
}
