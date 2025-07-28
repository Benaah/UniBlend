import 'package:flutter/material.dart';

class EventTrendingScreen extends StatelessWidget {
  const EventTrendingScreen({super.key});

  final List<Map<String, String>> trendingEvents = const [
    {
      'title': 'Summer Music Festival',
      'date': '2025-07-15',
      'description': 'Join the biggest music festival of the summer!',
    },
    {
      'title': 'Art & Culture Expo',
      'date': '2025-08-01',
      'description': 'Explore the latest in art and culture.',
    },
    {
      'title': 'Tech Innovators Conference',
      'date': '2025-09-10',
      'description': 'Discover cutting-edge technology trends.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending Events')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trendingEvents.length,
        itemBuilder: (context, index) {
          final event = trendingEvents[index];
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
