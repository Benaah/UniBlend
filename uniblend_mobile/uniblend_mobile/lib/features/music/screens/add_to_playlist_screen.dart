import 'package:flutter/material.dart';

class AddToPlaylistScreen extends StatelessWidget {
  const AddToPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add to Playlist')),
      body: Center(
        child: Text('Add To Playlist Screen'),
      ),
    );
  }
}
