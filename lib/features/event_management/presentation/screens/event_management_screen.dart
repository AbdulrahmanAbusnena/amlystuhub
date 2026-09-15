import 'package:amlystuhub/features/event_management/presentation/controllers/bbq_controllers.dart'; 
import 'package:amlystuhub/features/event_management/presentation/widgets/finance_card.dart'; 
import 'package:flutter/material.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

class EventManagementScreen extends ConsumerWidget {
  const EventManagementScreen({super.key});

  @override 
  Widget build(BuildContext context, Widget ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.sync), 
            tooltip: 'Sync Sheets Data', 
            onPressed: () {
              ref.read(bbqRosterControllerProvider.notifier).refreshRoster(); 
            },
          )
        ]
        ), 
      body: const Padding(
        padding: EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            BbQFinanceCards(), 
            SizedBox(height: 16), 
            Text(
              'Attendance Roster', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), 
            ), 
            SizedBox(height: 8), 
            Expanded(child: BbqRosterView()), 
          ],
        )
      ),
    );
  } 
}
