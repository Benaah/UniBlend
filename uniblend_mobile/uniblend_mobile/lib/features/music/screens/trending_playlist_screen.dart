import 'package:flutter/material.dart';

class TrendingPlaylistScreen extends StatelessWidget {
  const TrendingPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending Playlist')),
      body: Center(
        child: Text('Trending Playlist Screen'),
      ),
    );
  }
}
