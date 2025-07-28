import 'package:flutter/material.dart';

class DeleteChatScreen extends StatelessWidget {
  const DeleteChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Chat')),
      body: Center(child: Text('Delete Chat Screen')),
    );
  }
}
