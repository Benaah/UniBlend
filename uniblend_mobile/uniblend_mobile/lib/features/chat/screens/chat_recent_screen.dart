import 'package:flutter/material.dart';

class ChatRecentScreen extends StatelessWidget {
  const ChatRecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Chats')),
      body: Center(child: Text('Chat Recent Screen')),
    );
  }
}
