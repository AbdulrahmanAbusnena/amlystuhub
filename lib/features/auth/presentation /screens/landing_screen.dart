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
      height: 80,
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

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: SizedBox(
                width: 120,
                height: 100,
                child: InkWell(
                  onTap: () => context.go('/login'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    alignment: Alignment.center,
                    child: const Text(
                      'Login In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Text('/', style: TextStyle(fontSize: 24, color: Colors.black)),
          TextButton(
            onPressed: () => context.go('/signup'),
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildbody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AMLYSTUHUB.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'A centralized student platform designed for managing academic tasks and collaborative projects.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('GET STARTED'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buidfooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '© 2026 AMLYSTUHUB',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
