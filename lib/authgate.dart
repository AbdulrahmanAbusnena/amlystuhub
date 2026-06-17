import 'package:amlystuhub/features/auth/presentation%20/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGateKeeper extends ConsumerWidget {
  const AuthGateKeeper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStreamProvider); 

    return authState.when(
      data: (user) {
        if (user != null) {
          // User is authenticated, show the main app
          return const ();
        } else {
          // User is not authenticated, show the login screen
          return const;
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}
