import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amlystuhub/core/widgets/primary_button.dart';
import 'package:amlystuhub/core/widgets/app_header.dart';
import 'package:amlystuhub/core/widgets/responsive_layout.dart';

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
      body: SafeArea(
        child: SelectionArea(
          // Enables text copying across the entire viewport canvas
          child: Column(
            children: [
              AppHeader(),
              Expanded(child: _buildbody(context)),
              _buidfooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildheader(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 700;

    return Container(
      height: isSmall ? 64 : 80,
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 16.0 : 24.0),
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
              fontSize: isSmall ? 20 : 24,
            ),
          ),
          const Spacer(),

          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              width: isSmall ? 100 : 120,
              height: isSmall ? 44 : 56,
              child: InkWell(
                onTap: () => context.go('/login'),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: isSmall ? 8 : 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmall ? 14 : 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (!isSmall) ...[
            const SizedBox(width: 8),
            const Text('/', style: TextStyle(fontSize: 24, color: Colors.black)),
            TextButton(
              onPressed: () => context.go('/signup'),
              style: TextButton.styleFrom(
                enabledMouseCursor: SystemMouseCursors.click,
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextButton(
                onPressed: () => context.go('/signup'),
                style: TextButton.styleFrom(
                  enabledMouseCursor: SystemMouseCursors.click,
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
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

              PrimaryButton(
                label: 'GET STARTED',
                onPressed: () => context.go('/signup'),
                width: 200,
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buidfooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Clearer, standard weight copyright stamp
          Text(
            '© 2026 AMLYSTUHUB',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          // Contact Readouts
          Row(
            children: [
              Text(
                'Contact: abdulrahmanabusnena01@gmail.com',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Tel: 091609518',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
