import 'package:amlystuhub/core/widgets/app_header_dash.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);
    final studentName = userState.value?.name;
    final userRole = userState.value?.role ?? 'student';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SelectionArea(
          child: Column(
            children: [
              AppHeaderDash(title: 'Welcome, ${studentName ?? 'Student'}.'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 40.0,
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Clean minimalist dynamic welcome header block
                          Text(
                            'DASHBOARD.',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.5,
                                  fontSize: 48,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Real-time campus broadcasts and student council updates.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color
                                      ?.withOpacity(0.6),
                                ),
                          ),

                          // If user is a Stuco Lead, show a sleek navigation link button to the Admin Panel
                          if (userRole == 'stuco_leads') ...[
                            const SizedBox(height: 24),
                            OutlinedButton.icon(
                              onPressed: () => context.go('/admin'),
                              icon: const Icon(
                                Icons.admin_panel_settings_outlined,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'OPEN ADMIN WORKSPACE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 48),
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

  Widget _buildLiveAnnouncementsFeed(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('announcements')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // 🛑 This prints the EXACT Firestore failure reason to your debug console terminal!
          debugPrint("💥 FIRESTORE STREAM FAILURE: ${snapshot.error}");

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: Border.all(color: Colors.red, width: 1.5) != null
                ? BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1.5),
                  )
                : null,
            child: Text(
              'STREAM LOG ERROR:\n${snapshot.error}',
              style: const TextStyle(
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: LinearProgressIndicator(
              color: Colors.black,
              backgroundColor: Colors.transparent,
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: const Center(
              child: Text(
                'No active broadcasts in terminal log.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        // Sort programmatically on client side to avoid index crashes
        final sortedDocs = List<QueryDocumentSnapshot>.from(docs)
          ..sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aTime = aData['createdAt'] as Timestamp?;
            final bTime = bData['createdAt'] as Timestamp?;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedDocs.length,
          itemBuilder: (context, index) {
            final data = sortedDocs[index].data() as Map<String, dynamic>;
            return _buildMinimalistAnnouncementCard(context, data);
          },
        );
      },
    );
  }

  Widget _buildMinimalistAnnouncementCard(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (data['category'] ?? 'GENERAL').toString().toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                'FROM: ${data['authorName'] ?? 'STUCO'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            data['title'] ?? 'Untitled Update',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['content'] ?? '',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
