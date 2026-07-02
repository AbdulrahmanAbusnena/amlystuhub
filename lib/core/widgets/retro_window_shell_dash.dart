import 'package:flutter/material.dart';

class RetroWindowShellDash extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const RetroWindowShellDash({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.colorScheme.onSurface, width: 2),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            children: [
              // Header Windows Title Bar (Seamless canvas)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor, // Your custom pink color tint
                  // 🏁 Bottom border removed entirely to clean up the workspace canvas layout!
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Window Indicators + Title Text
                    Row(
                      children: [
                        const Text('🟡 🟢 🔴 ', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                20, // Slightly reduced to guarantee space for text strings
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    // Right Actions Bracket (Where buttons from sketch will render)
                    if (actions != null) Row(children: actions!),
                  ],
                ),
              ),

              // Divider space if wanted, or pure expanded content stream
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
