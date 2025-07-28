import 'package:flutter/material.dart';

class GalleryFavoritesScreen extends StatelessWidget {
  const GalleryFavoritesScreen({super.key});

  final List<Map<String, String>> favoritePosts = const [
    {
      'imageUrl': 'https://example.com/image1.jpg',
      'caption': 'Beautiful sunset at the beach',
      'user': 'user123',
    },
    {
      'imageUrl': 'https://example.com/image2.jpg',
      'caption': 'Delicious homemade pizza',
      'user': 'foodie42',
    },
    {
      'imageUrl': 'https://example.com/image3.jpg',
      'caption': 'Hiking adventures in the mountains',
      'user': 'naturelover',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery Favorites')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoritePosts.length,
        itemBuilder: (context, index) {
          final post = favoritePosts[index];
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
