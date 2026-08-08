import 'package:amlystuhub/features/announcements/presentation/widgets/announcement_creation.dart';
import 'package:amlystuhub/features/auth/domain/models%20/user_role.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/announcement_feed.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateAnnouncementDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final user = userAsync.value;

    final isPrivilegedUser = user != null && (user.role == UserRole.stuCoAdmin);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (isPrivilegedUser)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton.filled(
                icon: const Icon(Icons.add_comment_outlined),
                tooltip: 'Post Announcement',
                onPressed: () => _showCreateDialog(context),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Banner bar clarifying privileges
          if (isPrivilegedUser)
            Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings_outlined,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Admin Mode: Viewing all grade scopes & publishing enabled.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Main Announcement List
          const Expanded(child: AnnouncementFeed()),
        ],
      ),

      // Floating Action Button for mobile / primary layout trigger
      floatingActionButton: isPrivilegedUser
          ? FloatingActionButton.extended(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Post'),
            )
          : null,
    );
  }
}
