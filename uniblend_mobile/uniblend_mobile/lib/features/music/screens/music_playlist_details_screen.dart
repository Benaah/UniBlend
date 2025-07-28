import 'package:flutter/material.dart';

class MusicPlaylistDetailsScreen extends StatelessWidget {
  const MusicPlaylistDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist Details')),
      body: Center(
        child: Text('Music Playlist Details Screen'),
      ),
    );
  }
}
