import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/services/api_service.dart';
import 'features/auth/presentation/auth_provider.dart';
import 'features/notifications/presentation/notification_provider.dart';
import 'features/music/providers/music_provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/notifications/presentation/notifications_screen.dart';
import 'features/music/screens/music_discovery_screen.dart';
import 'core/widgets/main_navigation.dart';
import 'core/themes/kenyan_theme.dart';

void main() {
  // Initialize API service
  ApiService().init();
  
  runApp(const UniBlendApp());
}

class UniBlendApp extends StatelessWidget {
  const UniBlendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => MusicProvider()),
      ],
      child: MaterialApp(
        title: 'UniBlend',
        theme: KenyanTheme.lightTheme,
        darkTheme: KenyanTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainNavigation(),
          '/notifications': (context) => const NotificationsScreen(),
          '/music': (context) => const MusicDiscoveryScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while checking auth status
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'UniBlend',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Connect. Learn. Blend.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Navigate based on authentication status
        if (authProvider.isAuthenticated) {
          // Initialize providers when user is authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<NotificationProvider>().initialize();
            context.read<MusicProvider>().initialize();
          });
          return const MainNavigation();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
