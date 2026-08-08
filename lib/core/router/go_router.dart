import 'package:amlystuhub/features/announcements/presentation/widgets/announcemen_screen.dart';
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
      final authAsync = ref.read(authStreamProvider);
      final user = authAsync.value;

      final isLoggingInOrLanding =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/landing';

      if (user == null) {
        return isLoggingInOrLanding ? null : '/landing';
      }

      if (isLoggingInOrLanding) {
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
      GoRoute(
        path: '/announcements',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Announcement Test')),
          body: const AnnouncementsScreen(),
        ),
      ),
    ],
  );

  ref.listen(authStreamProvider, (_, __) => router.refresh());
  ref.listen(currentUserModelProvider, (_, __) => router.refresh());

  return router;
});
