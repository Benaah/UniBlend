class ApiConfig {
  static const String baseUrl = 'https://uniblend.test'; // Change to your Laravel API URL
  static const String tokenKey = 'auth_token';

  // API endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String userEndpoint = '/user';
  static const String threadsEndpoint = '/threads';
  static const String postsEndpoint = '/posts';
  static const String profileEndpoint = '/profile';
  static const String bookingsEndpoint = '/bookings';
  static const String walletsEndpoint = '/wallets';
  static const String notificationsEndpoint = '/notifications';
  
  // Music endpoints
  static const String musicTracksEndpoint = '/music-tracks';
  static const String playlistsEndpoint = '/playlists';
  static const String musicGenresEndpoint = '/music-genres';
  static const String favoritesEndpoint = '/favorites';
  static const String searchMusicEndpoint = '/music/search';

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
