import 'dart:async';

import 'package:amlystuhub/features/auth/presentation%20/controllers/auth_controllers.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/landing_screen.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/login_screen.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/signup_screen.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// screens
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Listen to the stream for reactive listener updates WITHOUT destroying the router object
  final authStream = ref.watch(authServiceProvider).authStateChanges;

  return GoRouter(
    initialLocation: '/landing', // Restoring your exact layout route target
    refreshListenable: GoRouterRefreshStream(authStream),

    redirect: (context, state) {
      // READ the current value inside the redirect callback instead of watching it at the provider root
      final user = ref.read(authStreamProvider).value;

      final isLoggingInOrLanding =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/landing';

      // 1. Guard Condition: User is NOT logged in
      if (user == null) {
        // Force them to landing or auth paths. If they try to go to dashboard, slam the door.
        return isLoggingInOrLanding ? null : '/landing';
      }

      // 2. Guard Condition: User IS logged in
      // If they are authenticated, intercept landing/login/signup and forward to dashboard
      if (isLoggingInOrLanding) {
        return '/dashboard';
      }

      // No redirect needed, proceed to target location safely
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const Login()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUp()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Dashboard(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
