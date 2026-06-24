import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxContentWidth;

  const ResponsiveLayout({
    Key? key,
    required this.child,
    this.maxContentWidth = 900,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: child,
        ),
      ),
    );
  }
}
