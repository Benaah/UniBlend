import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  final List<Map<String, String>> events = const [
    {
      'title': 'Music Festival',
      'date': '2024-07-15',
      'description': 'Join the biggest music festival of the summer!',
    },
    {
      'title': 'Art & Culture Expo',
      'date': '2024-08-01',
      'description': 'Explore the latest in art and culture.',
    },
    {
      'title': 'Tech Innovators Conference',
      'date': '2024-09-10',
      'description': 'Discover cutting-edge technology trends.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(event['title']!),
              subtitle: Text('${event['date']} - ${event['description']}'),
              onTap: () {
                // TODO: Navigate to event details
              },
            ),
          );
        },
      ),
    );
  }
}
