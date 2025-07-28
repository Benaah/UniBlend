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
            '/onboarding': (_) => UniBlendOnboarding(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/reset-password': (context) => const ResetPasswordScreen(),
            '/verify-email': (context) => const VerifyEmailScreen(),
            '/email-verification': (context) => const EmailVerificationScreen(),
            '/phone-verification': (context) => const PhoneVerificationScreen(),
            '/update-password': (context) => const UpdatePasswordScreen(),
            '/home': (context) => const MainNavigation(),
            '/connect': (context) => const ConnectScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            '/music': (context) => const MusicDiscoveryScreen(),
            '/music/details': (context) => const MusicDetailsScreen(),
            '/music/player': (context) => const MusicPlayerScreen(),
            '/music/playlist': (context) => const MusicPlaylistScreen(),
            '/music/playlist/details': (context) => const MusicPlaylistDetailsScreen(),
            '/music/playlist/create': (context) => const CreatePlaylistScreen(),
            '/music/playlist/edit': (context) => const EditPlaylistScreen(),
            '/music/playlist/add': (context) => const AddToPlaylistScreen(),
            '/music/playlist/remove': (context) => const RemoveFromPlaylistScreen(),
            '/music/playlist/favorites': (context) => const FavoritesScreen(),
            '/music/playlist/recent': (context) => const RecentPlaylistScreen(),
            '/music/playlist/trending': (context) => const TrendingPlaylistScreen(),
            '/music/playlist/search': (context) => const MusicSearchScreen(),
            '/learn': (context) => const LearnScreen(),
            '/learn/details': (context) => const FlashClassDetailsScreen(),
            '/learn/create': (context) => const CreateLearnScreen(),
            '/learn/edit': (context) => const EditLearnScreen(),
            '/gallery': (context) => const GalleryScreen(),
            '/gallery/details': (context) => const GalleryDetailsScreen(),
            '/gallery/upload': (context) => const UploadGalleryScreen(),
            '/gallery/edit': (context) => const EditGalleryScreen(),
            '/gallery/delete': (context) => const DeleteGalleryScreen(),
            '/gallery/favorites': (context) => const GalleryFavoritesScreen(),
            '/gallery/recent': (context) => const GalleryRecentScreen(),
            '/gallery/trending': (context) => const GalleryTrendingScreen(),
            '/gallery/search': (context) => const GallerySearchScreen(),
            '/wallet': (context) => const WalletScreen(),
            '/wallet/details': (context) => const WalletDetailsScreen(),
            '/wallet/create': (context) => const CreateWalletScreen(),
            '/wallet/edit': (context) => const EditWalletScreen(),
            '/wallet/delete': (context) => const DeleteWalletScreen(),
            '/wallet/fund': (context) => const WalletFundScreen(),
            '/wallet/withdraw': (context) => const WalletWithdrawScreen(),
            '/wallet/transactions': (context) => const WalletTransactionsScreen(),
            '/wallet/history': (context) => const WalletHistoryScreen(),
            '/wallet/favorites': (context) => const WalletFavoritesScreen(),
            '/wallet/recent': (context) => const WalletRecentScreen(),
            '/events': (context) => const EventsScreen(),
            '/events/details': (context) => const EventDetailsScreen(),
            '/events/create': (context) => const CreateEventScreen(),
            '/events/edit': (context) => const EditEventScreen(),
            '/events/delete': (context) => const DeleteEventScreen(),
            '/events/favorites': (context) => const EventFavoritesScreen(),
            '/events/recent': (context) => const EventRecentScreen(),
            '/events/trending': (context) => const EventTrendingScreen(),
            '/events/search': (context) => const EventSearchScreen(),
            '/chat': (context) => const ChatScreen(),
            '/chat/details': (context) => const ChatDetailsScreen(),
            '/chat/create': (context) => const CreateChatScreen(),
            '/chat/edit': (context) => const EditChatScreen(),
            '/chat/delete': (context) => const DeleteChatScreen(),
            '/chat/favorites': (context) => const ChatFavoritesScreen(),
            '/chat/recent': (context) => const ChatRecentScreen(),
            '/chat/trending': (context) => const ChatTrendingScreen(),
            '/chat/search': (context) => const ChatSearchScreen(),
            '/services': (context) => const ServicesScreen(),
            '/services/details': (context) => const ServiceDetailsScreen(),
            '/services/create': (context) => const CreateServiceScreen(),
            '/services/edit': (context) => const EditServiceScreen(),
            '/services/delete': (context) => const DeleteServiceScreen(),
            '/services/favorites': (context) => const ServiceFavoritesScreen(),
            '/services/recent': (context) => const ServiceRecentScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/profile/edit': (context) => const EditProfileScreen(),
            '/profile/settings': (context) => const ProfileSettingsScreen(),
            '/profile/privacy': (context) => const ProfilePrivacyScreen(),
            '/profile/security': (context) => const ProfileSecurityScreen(),
            '/profile/notifications': (context) => const ProfileNotificationsScreen(),
            '/profile/help': (context) => const ProfileHelpScreen(),
            '/profile/about': (context) => const ProfileAboutScreen(),
            '/profile/terms': (context) => const ProfileTermsScreen(),
            '/profile/privacy-policy': (context) => const ProfilePrivacyPolicyScreen(),
            '/profile/contact': (context) => const ProfileContactScreen(),
            '/profile/logout': (context) => const ProfileLogoutScreen(),
            '/profile/delete-account': (context) => const DeleteAccountScreen(),
            '/profile/feedback': (context) => const FeedbackScreen(),
            '/profile/faq': (context) => const FaqScreen(),
            '/profile/support': (context) => const SupportScreen(),
            '/profile/updates': (context) => const UpdatesScreen(),
            '/profile/notifications/settings': (context) => const NotificationSettingsScreen(),
            '/profile/music/settings': (context) => const MusicSettingsScreen(),
            '/profile/gallery/settings': (context) => const GallerySettingsScreen(),
            '/profile/events/settings': (context) => const EventSettingsScreen(),
            '/profile/chat/settings': (context) => const ChatSettingsScreen(),
            '/profile/flashclass/settings': (context) => const FlashClassSettingsScreen(),
            '/profile/services/services': (context) => const ServicesSettingsScreen(),
            '/profile/wallet/settings': (context) => const WalletSettingsScreen(),
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
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 6,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'UniBlend',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.deepPurple,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Connect. Learn. Blend.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
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
