import 'package:flutter/material.dart';

class ChatFavoritesScreen extends StatelessWidget {
  const ChatFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Favorites')),
      body: Center(child: Text('Chat Favorites Screen')),
    );
  }
}
