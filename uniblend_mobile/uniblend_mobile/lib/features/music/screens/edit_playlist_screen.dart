import 'package:flutter/material.dart';

class EditPlaylistScreen extends StatelessWidget {
  const EditPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Playlist')),
      body: Center(
        child: Text('Edit Playlist Screen'),
      ),
    );
  }
}
