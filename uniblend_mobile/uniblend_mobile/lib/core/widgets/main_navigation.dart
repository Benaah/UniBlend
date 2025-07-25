import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../../features/learn/presentation/learn_screen.dart';
import '../../features/connect/presentation/connect_screen.dart';
import '../../features/gallery/presentation/gallery_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = const [
    LearnScreen(),
    ConnectScreen(),
    GalleryScreen(),
    ServicesScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: _onItemTapped,
        backgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.play_circle_outline),
            title: const Text('Learn'),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.forum_outlined),
            title: const Text('Connect'),
            activeColor: Colors.green,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.photo_library_outlined),
            title: const Text('Gallery'),
            activeColor: Colors.purple,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.room_service_outlined),
            title: const Text('Services'),
            activeColor: Colors.orange,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
