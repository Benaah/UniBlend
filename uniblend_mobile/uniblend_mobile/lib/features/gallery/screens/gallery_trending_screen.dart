import 'package:flutter/material.dart';

class GalleryTrendingScreen extends StatelessWidget {
  const GalleryTrendingScreen({super.key});

  final List<Map<String, String>> trendingPosts = const [
    {
      'imageUrl': 'https://example.com/trending1.jpg',
      'caption': 'Sunset over the mountains',
      'user': 'mountain_hiker',
    },
    {
      'imageUrl': 'https://example.com/trending2.jpg',
      'caption': 'City lights at night',
      'user': 'night_owl',
    },
    {
      'imageUrl': 'https://example.com/trending3.jpg',
      'caption': 'Delicious brunch spread',
      'user': 'foodie_life',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending Gallery')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trendingPosts.length,
        itemBuilder: (context, index) {
          final post = trendingPosts[index];
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
