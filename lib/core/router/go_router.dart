import 'package:amlystuhub/features/academics/presentation/screens/academic_hub.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/landing_screen.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/login_screen.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/signup_screen.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/dashboard_screen.dart';
import 'package:amlystuhub/features/profile/presentation/screens/profile_admin_view.dart';
import 'package:amlystuhub/features/profile/presentation/screens/profile_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/advocacy/presentation/screens/advocacty_screen.dart';
import '../../features/announcements/presentation/widgets/announcemen_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final authAsync = ref.read(authStreamProvider);
      final userModelAsync = ref.read(currentUserModelProvider);
      final user = authAsync.value;
      final userModel = userModelAsync.value;

      final isAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/landing';

      if (user == null) {
        return isAuthPage ? null : '/landing';
      }

      if (isAuthPage) {
        return '/dashboard';
      }

      // Restrict Admin Profile Requests route to StuCo Admins
      if (state.matchedLocation == '/admin/profile-requests') {
        if (userModel == null || !userModel.isStuCoAdmin) {
          return '/dashboard';
        }
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
        builder: (context, state) => DashboardScreen(
          onNavigateToTab: (index) {
            switch (index) {
              case 1:
                context.go('/announcements');
                break;
              case 2:
                context.go('/academics');
                break;
              case 3:
                context.go('/advocacy');
                break;
              case 4:
                context.go('/profile');
                break;
              default:
                context.go('/dashboard');
                break;
            }
          },
        ),
      ),
      GoRoute(
        path: '/announcements',
        builder: (context, state) => const AnnouncementsScreen(),
      ),
      GoRoute(
        path: '/academics',
        builder: (context, state) => const AcademicHubScreen(),
      ),
      GoRoute(
        path: '/advocacy',
        builder: (context, state) => const AdvocacyHubScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/admin/profile-requests',
        builder: (context, state) => const AdminProfileRequestsPage(),
      ),
    ],
  );

  ref.listen(authStreamProvider, (_, __) => router.refresh());
  ref.listen(currentUserModelProvider, (_, __) => router.refresh());

  return router;
});
