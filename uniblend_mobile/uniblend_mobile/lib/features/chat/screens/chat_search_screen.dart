import 'package:flutter/material.dart';

class ChatSearchScreen extends StatelessWidget {
  const ChatSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Chats')),
      body: Center(child: Text('Chat Search Screen')),
    );
  }
}
