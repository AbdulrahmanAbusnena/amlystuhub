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

    final isPrivilegedUser = user != null && user.role == UserRole.stuCoAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: const AnnouncementFeed(),
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
