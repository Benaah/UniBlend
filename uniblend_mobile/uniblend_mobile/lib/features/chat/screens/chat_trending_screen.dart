import 'package:flutter/material.dart';

class ChatTrendingScreen extends StatelessWidget {
  const ChatTrendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending Chats')),
      body: Center(child: Text('Chat Trending Screen')),
    );
  }
}
