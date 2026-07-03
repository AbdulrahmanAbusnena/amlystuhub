import 'package:amlystuhub/core/widgets/app_header_dash.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section: System Update Status Bar Matrix
                          _buildSystemStatusBanner(context),
                          const SizedBox(height: 40),

                          // Section: Announcements Feed Label
                          Text(
                            'CAMPUS BROADCASTS',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color
                                      ?.withOpacity(0.5),
                                ),
                          ),
                          const SizedBox(height: 16),

                          // Section: Real-time Firestore Stream Feed
                          _buildLiveAnnouncementsFeed(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
