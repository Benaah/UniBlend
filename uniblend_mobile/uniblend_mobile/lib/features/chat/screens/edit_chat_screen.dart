import 'package:flutter/material.dart';

class EditChatScreen extends StatelessWidget {
  const EditChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Chat')),
      body: Center(child: Text('Edit Chat Screen')),
    );
  }
}
