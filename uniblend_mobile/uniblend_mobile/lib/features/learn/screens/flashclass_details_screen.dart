import 'package:flutter/material.dart';

class FlashClassDetailsScreen extends StatelessWidget {
  const FlashClassDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example detailed view for a flash class
    return Scaffold(
      appBar: AppBar(title: const Text('FlashClass Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'FlashClass Title',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Instructor: John Doe',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          Image.network(
            'https://example.com/flashclass-image.jpg',
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          const Text(
            'This is a detailed description of the flash class. It covers the topics, objectives, and other relevant information to help learners understand what to expect.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement enrollment or start class action
            },
            child: const Text('Start Class'),
          ),
        ],
      ),
    );
  }
}
