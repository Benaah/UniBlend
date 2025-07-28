import 'package:flutter/material.dart';

class MusicSearchScreen extends StatelessWidget {
  const MusicSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Search')),
      body: Center(
        child: Text('Music Search Screen'),
      ),
    );
  }
}
