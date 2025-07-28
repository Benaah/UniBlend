import 'package:flutter/material.dart';

class DeleteServiceScreen extends StatelessWidget {
  const DeleteServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Service')),
      body: Center(child: Text('Delete Service Screen')),
    );
  }
}
