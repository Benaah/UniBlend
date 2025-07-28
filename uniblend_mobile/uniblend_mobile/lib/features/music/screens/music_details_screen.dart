import 'package:flutter/material.dart';

class MusicDetailsScreen extends StatelessWidget {
  const MusicDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Details')),
      body: Center(
        child: Text('Music Details Screen'),
      ),
    );
  }
}
