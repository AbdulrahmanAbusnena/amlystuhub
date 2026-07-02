import 'package:amlystuhub/core/widgets/retro_window_shell_dash.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    // listen to the auth/user provider
    final userState = ref.watch(currentUserProvider);

    // extracting the students' name

    final studentName = userState.value?.name;
    return RetroWindowShellDash(
      title: 'Welcome Back, $studentName!',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 700;
                final imageSize = isSmall ? 140.0 : 210.0;

                return Row();
              },
            ),
          ],
        ),
      ),
    );
  }
}
