import 'package:flutter/material.dart';

class RecentPlaylistScreen extends StatelessWidget {
  const RecentPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Playlist')),
      body: Center(
        child: Text('Recent Playlist Screen'),
      ),
    );
  }
}
