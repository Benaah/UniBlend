import 'package:flutter/material.dart';

class RemoveFromPlaylistScreen extends StatelessWidget {
  const RemoveFromPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remove from Playlist')),
      body: Center(
        child: Text('Remove From Playlist Screen'),
      ),
    );
  }
}
