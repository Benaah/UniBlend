import 'package:flutter/material.dart';

class CreatePlaylistScreen extends StatelessWidget {
  const CreatePlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Playlist')),
      body: Center(
        child: Text('Create Playlist Screen'),
      ),
    );
  }
}
