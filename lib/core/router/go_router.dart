import 'package:amlystuhub/features/announcements/presentation/widgets/announcement_creation.dart';
import 'package:flutter/material.dart';
import 'package:amlystuhub/features/announcements/presentation/widgets/announcement_feed.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// screen imports
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/landing_screen.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/login_screen.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/signup_screen.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/dashboard.dart';
import 'package:amlystuhub/features/resources/presentation/screens/resources.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/landing',

    redirect: (context, state) {
      // Safely read the auth state value from your provider without setting up a destructive watch loop
      final user = ref.read(authStreamProvider).value;
      final userProfile = ref.read(currentUserModelProvider).value;

      final isLoggingInOrLanding =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/landing';

      // 1. Guard Condition: User is NOT logged in
      if (user == null) {
        return isLoggingInOrLanding ? null : '/landing';
      }

      // 2. Guard Condition: User IS logged in
      if (isLoggingInOrLanding) {
        return '/announcements';
      }

      if (userProfile?.role != 'stuco_leads') {
        return '/announcements';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const Login()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUp()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Dashboard(),
      ),
      GoRoute(
        path: '/resources',
        builder: (context, state) => const ResourcesScreen(),
      ),
      // 🛠️ Wrapped in a Scaffold so layout & themes render correctly while testing
      GoRoute(
        path: '/announcements',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Announcement  Test')),
          body: const CreateAnnouncementDialog(),
        ),
      ),
    ],
  );

  ref.listen(authStreamProvider, (previous, next) {
    router.refresh();
  });

  return router;
});
