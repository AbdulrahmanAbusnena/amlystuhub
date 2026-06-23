import 'package:amlystuhub/features/auth/presentation%20/controllers/auth_controllers.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/login_screen.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/signup_screen.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/dashboard.dart';
import 'package:go_router/go_router.dart';

// screens
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStateAsync = ref.watch(authStreamProvider);

  return GoRouter(
    initialLocation: '/login',
    // Redirect logic acts as our security guard gatekeeper
    redirect: (context, state) {
      // Get the value of the current stream snapshot (null means logged out)
      final user = authStateAsync.value;

      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      // 1. Guard Condition: If the student is not logged in, force them to stay on auth screens
      if (user == null) {
        return isLoggingIn ? null : '/login';
      }

      // 2. Guard Condition: If they are logged in and trying to go to login/signup, send them to dashboard
      if (isLoggingIn) {
        return '/dashboard';
      }

      // No redirect needed, proceed to target location
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const Login()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUp()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Dashboard(),
      ),
    ],
  );
});
