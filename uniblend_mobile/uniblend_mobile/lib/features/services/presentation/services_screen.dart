import 'package:flutter/material.dart';
import 'transport_booking_screen.dart';
import 'food_delivery_booking_screen.dart';
import 'booking_details_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  void _showCurrentLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Current location feature coming soon!')),
    );
  }

  void _triggerSOS(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Emergency SOS triggered! Help is on the way.')),
    );
  }

  void _navigateToBooking(BuildContext context, String service) {
    if (service == 'Transport') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TransportBookingScreen()),
      );
    } else if (service == 'Food Delivery') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FoodDeliveryBookingScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking for \$service is not implemented yet.')),
      );
    }
  }

  void _navigateToBookingDetails(BuildContext context, String service, String status, String time) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingDetailsScreen(
          service: service,
          status: status,
          time: time,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => _showCurrentLocation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency SOS Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emergency,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Emergency SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _triggerSOS(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('SOS'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Service categories
            const Text(
              'Available Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Service grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _ServiceCard(
                  icon: Icons.directions_car,
                  title: 'Transport',
                  description: 'Campus shuttle & rides',
                  color: Colors.blue,
                  onTap: () => _navigateToBooking(context, 'Transport'),
                ),
                _ServiceCard(
                  icon: Icons.restaurant,
                  title: 'Food Delivery',
                  description: 'Order from cafeteria',
                  color: Colors.green,
                  onTap: () => _navigateToBooking(context, 'Food Delivery'),
                ),
                _ServiceCard(
                  icon: Icons.local_laundry_service,
                  title: 'Laundry',
                  description: 'Pickup & delivery',
                  color: Colors.purple,
                  onTap: () => _navigateToBooking(context, 'Laundry'),
                ),
                _ServiceCard(
                  icon: Icons.cleaning_services,
                  title: 'Cleaning',
                  description: 'Room cleaning service',
                  color: Colors.teal,
                  onTap: () => _navigateToBooking(context, 'Cleaning'),
                ),
                _ServiceCard(
                  icon: Icons.book,
                  title: 'Tutoring',
                  description: 'Academic support',
                  color: Colors.orange,
                  onTap: () => _navigateToBooking(context, 'Tutoring'),
                ),
                _ServiceCard(
                  icon: Icons.build,
                  title: 'Maintenance',
                  description: 'Room repairs',
                  color: Colors.brown,
                  onTap: () => _navigateToBooking(context, 'Maintenance'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent bookings
            const Text(
              'Recent Bookings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Booking list
            _BookingCard(
              service: 'Campus Shuttle',
              status: 'In Progress',
              time: '10:30 AM',
              statusColor: Colors.orange,
              onTap: () => _navigateToBookingDetails(context, 'Campus Shuttle', 'In Progress', '10:30 AM'),
            ),
            _BookingCard(
              service: 'Food Delivery',
              status: 'Delivered',
              time: '12:15 PM',
              statusColor: Colors.green,
              onTap: () => _navigateToBookingDetails(context, 'Food Delivery', 'Delivered', '12:15 PM'),
            ),
            _BookingCard(
              service: 'Laundry Service',
              status: 'Scheduled',
              time: '2:00 PM',
              statusColor: Colors.blue,
              onTap: () => _navigateToBookingDetails(context, 'Laundry Service', 'Scheduled', '2:00 PM'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String service;
  final String status;
  final String time;
  final Color statusColor;
  final VoidCallback onTap;

  const _BookingCard({
    required this.service,
    required this.status,
    required this.time,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(
            Icons.receipt_long,
            color: statusColor,
          ),
        ),
        title: Text(
          service,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(time),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
