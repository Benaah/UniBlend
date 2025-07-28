import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String service;
  final String status;
  final String time;

  const BookingDetailsScreen({
    super.key,
    required this.service,
    required this.status,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: \$service',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Status: \$status',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Time: \$time',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement cancel or modify booking
              },
              child: const Text('Cancel Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
