import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(child: Column(children: [_buildheader(context)])),
    );
  }

  Widget _buildheader(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            'AMLYSTUHUB',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 24,
            ),
          ),
          Spacer(),

          TextButton(
            onPressed: () => context.go('/login'),
            child: Text('SIGN IN', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }

  Widget _buildbody(BuildContext context) {
    return Container();
  }

  Widget _buidfooter(BuildContext context) {
    return Container();
  }
}
