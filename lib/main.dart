import 'package:amlystuhub/core/router/go_router.dart';
import 'package:amlystuhub/core/theme/theme_controller.dart';
import 'package:amlystuhub/features/auth/presentation%20/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'firebase_options.dart';

// Expose your theme class to the Riverpod engine cleanly
final appThemeProvider = ChangeNotifierProvider<ThemeProvider>((ref) {
  return ThemeProvider();
});

void main() async {
  // initiating firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme using Riverpod's ref pointer
    final themeProviderState = ref.watch(appThemeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AmlyStuHub',
      theme: themeProviderState.themeData,
      routerConfig: router,
    );
  }
}
