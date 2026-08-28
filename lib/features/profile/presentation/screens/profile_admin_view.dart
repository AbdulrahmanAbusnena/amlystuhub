import 'package:amlystuhub/features/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminProfileRequestsPage extends ConsumerWidget {
  const AdminProfileRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(adminPendingRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pending Profile Change Requests')),
      body: requestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No pending requests.'));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(req.studentName),
                  subtitle: Text(
                    '${req.studentEmail}\n'
                    'Grade: ${req.currentGradeLevel} ➔ ${req.requestedGradeLevel} | '
                    'AP: ${req.currentIsApStudent} ➔ ${req.requestedIsApStudent}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          ref
                              .read(profileControllerProvider.notifier)
                              .resolveAdminRequest(req, true);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          ref
                              .read(profileControllerProvider.notifier)
                              .resolveAdminRequest(req, false);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
