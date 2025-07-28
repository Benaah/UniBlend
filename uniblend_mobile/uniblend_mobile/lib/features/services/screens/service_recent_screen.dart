import 'package:flutter/material.dart';

class ServiceRecentScreen extends StatelessWidget {
  const ServiceRecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Services')),
      body: Center(child: Text('Service Recent Screen')),
    );
  }
}
