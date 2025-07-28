import 'package:flutter/material.dart';

class MusicPlaylistScreen extends StatelessWidget {
  const MusicPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Playlist')),
      body: Center(
        child: Text('Music Playlist Screen'),
      ),
    );
  }
}
