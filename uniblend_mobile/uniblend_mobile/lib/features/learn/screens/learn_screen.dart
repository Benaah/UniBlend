import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  final List<Map<String, String>> learnItems = const [
    {
      'title': 'Introduction to Music Theory',
      'description': 'Learn the basics of music theory including notes, scales, and chords.',
    },
    {
      'title': 'Advanced Guitar Techniques',
      'description': 'Master advanced guitar playing techniques and styles.',
    },
    {
      'title': 'Songwriting Workshop',
      'description': 'Develop your songwriting skills with practical exercises.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: learnItems.length,
        itemBuilder: (context, index) {
          final item = learnItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(item['title']!),
              subtitle: Text(item['description']!),
              onTap: () {
                // TODO: Navigate to learn item details
              },
            ),
          );
        },
      ),
    );
  }
}
