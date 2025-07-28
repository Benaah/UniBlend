import 'package:flutter/material.dart';

class GalleryRecentScreen extends StatelessWidget {
  const GalleryRecentScreen({super.key});

  final List<Map<String, String>> recentPosts = const [
    {
      'imageUrl': 'https://example.com/recent1.jpg',
      'caption': 'Morning coffee vibes',
      'user': 'coffee_lover',
    },
    {
      'imageUrl': 'https://example.com/recent2.jpg',
      'caption': 'City skyline at night',
      'user': 'urbanexplorer',
    },
    {
      'imageUrl': 'https://example.com/recent3.jpg',
      'caption': 'Freshly baked bread',
      'user': 'baker123',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Gallery')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recentPosts.length,
        itemBuilder: (context, index) {
          final post = recentPosts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  post['imageUrl']!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    post['caption']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Posted by @${post['user']}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
