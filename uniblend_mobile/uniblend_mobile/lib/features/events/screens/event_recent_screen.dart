import 'package:flutter/material.dart';

class EventRecentScreen extends StatelessWidget {
  const EventRecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual recent events list UI
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Events')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Recent Event 1'),
            subtitle: Text('Event details here'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Recent Event 2'),
            subtitle: Text('Event details here'),
          ),
          // Add more recent events here
        ],
      ),
    );
  }
}
