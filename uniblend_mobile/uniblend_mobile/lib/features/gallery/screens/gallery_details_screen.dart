import 'package:flutter/material.dart';

class GalleryDetailsScreen extends StatelessWidget {
  const GalleryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example social feed style gallery post details
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(
            'https://example.com/sample-image.jpg',
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          const Text(
            'Caption for the gallery post goes here. This is a detailed description of the post.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // TODO: Implement like functionality
                },
              ),
              const Text('123 likes'),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  // TODO: Implement comment functionality
                },
              ),
              const Text('45 comments'),
            ],
          ),
          const Divider(),
          const Text(
            'Comments',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('User1'),
            subtitle: const Text('Great post!'),
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('User2'),
            subtitle: const Text('Nice picture!'),
          ),
          // Add more comments here
        ],
      ),
    );
  }
}
