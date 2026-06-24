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
  final authStateAsync = ref.watch(authStreamProvider);
  final authStream = ref.watch(authServiceProvider).authStateChanges;

  return GoRouter(
    initialLocation: '/', // Changing root to the default clean path
    refreshListenable: GoRouterRefreshStream(authStream),

    redirect: (context, state) {
      final user = authStateAsync.value;

      // Classify the routes the user is targeting
      final isRootOrLanding = state.matchedLocation == '/';
      final isAuthScreen =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (user == null) {
        // If they are trying to reach login or signup, let them pass.
        // If they are trying to access dashboard or anything else, bounce to root (Landing Screen).
        return isAuthScreen ? null : '/';
      }

      // If they are logged in, do not let them see login, signup, or the landing page.
      if (isAuthScreen || isRootOrLanding) {
        return '/dashboard';
      }

      // No redirect needed, proceed to target protected location (e.g., dashboard)
      return null;
    },
    routes: [
      // Landing page now cleanly anchors the root URL
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const Login()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUp()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Dashboard(),
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
