import 'package:amlystuhub/core/widgets/app_header_dash.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: SelectionArea(
          child: Column(
            children: [
              AppHeaderDash(
                title: 'Welcome to Dashboard, ${studentName ?? 'Student'}!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
