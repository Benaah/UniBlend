import 'package:flutter/material.dart';

class EventFavoritesScreen extends StatelessWidget {
  const EventFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual favorites list UI
    return Scaffold(
      appBar: AppBar(title: const Text('Event Favorites')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text('Favorite Event 1'),
            subtitle: Text('Event details here'),
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text('Favorite Event 2'),
            subtitle: Text('Event details here'),
          ),
          // Add more favorite events here
        ],
      ),
    );
  }
}
