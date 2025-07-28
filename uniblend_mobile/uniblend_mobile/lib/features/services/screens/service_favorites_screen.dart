import 'package:flutter/material.dart';

class ServiceFavoritesScreen extends StatelessWidget {
  const ServiceFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Favorites')),
      body: Center(child: Text('Service Favorites Screen')),
    );
  }
}
