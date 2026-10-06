import 'package:amlystuhub/features/event_management/presentation/controllers/bbq_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/bbq_model.dart';

class BbqRosterView extends ConsumerWidget {
  const BbqRosterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterAsync = ref.watch(filteredBbqRosterProvider);

    return Column(
      children: [
        // Search TextField
        TextField(
          onChanged: (value) {
            ref.read(bbqSearchQueryProvider.notifier).state = value;
          },
          decoration: InputDecoration(
            hintText: 'Search by student name or grade...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Roster List Container
        Expanded(
          child: rosterAsync.when(
            data: (roster) {
              if (roster.isEmpty) {
                return const Center(
                  child: Text('No attendees match your query.'),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(bbqRosterControllerProvider.notifier)
                      .refreshRoster();
                },
                child: ListView.separated(
                  itemCount: roster.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final attendee = roster[index];
                    return ListTile(
                      title: Text(
                        attendee.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Class: ${attendee.grade}'),
                      trailing: Wrap(
                        spacing: 6,
                        children: [
                          _FoodChip(choice: attendee.foodChoice),
                          Chip(
                            label: Text(
                              attendee.hasPaid ? 'PAID' : 'UNPAID',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: attendee.hasPaid
                                ? Colors.green
                                : Colors.orange,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: ElevatedButton.icon(
                onPressed: () => ref
                    .read(bbqRosterControllerProvider.notifier)
                    .refreshRoster(),
                icon: const Icon(Icons.refresh),
                label: Text('Retry Loading ($err)'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FoodChip extends StatelessWidget {
  final FoodChoice choice;
  const _FoodChip({required this.choice});

  @override
  Widget build(BuildContext context) {
    String label = 'None';
    Color color = Colors.grey;

    if (choice == FoodChoice.chicken) {
      label = 'Chicken';
      color = Colors.amber.shade900;
    } else if (choice == FoodChoice.meat) {
      label = 'Meat';
      color = Colors.deepOrange;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
    );
  }
}
