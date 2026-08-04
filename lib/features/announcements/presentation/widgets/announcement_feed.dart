import 'package:amlystuhub/features/announcements/presentation/state/announcement_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'announcement_card.dart';

class AnnouncementFeed extends ConsumerWidget {
  const AnnouncementFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(filteredAnnouncementsProvider);

    return announcementsAsync.when(
      data: (announcements) {
        if (announcements.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Announcements Yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for updates from school admin and StuCo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            return AnnouncementCard(announcement: announcements[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Failed to load announcements: ${error.toString()}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
