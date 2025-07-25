import 'package:flutter/foundation.dart';
import '../../../shared/models/music_track.dart';
import '../../../shared/models/playlist.dart';
import '../../../shared/models/music_genre.dart';
import '../music_service.dart';
import 'package:just_audio/just_audio.dart';

class MusicProvider extends ChangeNotifier {
  final MusicService _musicService = MusicService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // State
  bool _isLoading = false;
  String? _error;
  
  // Music data
  List<MusicTrack> _featuredTracks = [];
  List<MusicTrack> _localTracks = [];
  List<MusicTrack> _favoriteTracks = [];
  List<Playlist> _playlists = [];
  List<MusicGenre> _genres = [];
  
  // Current playback
  MusicTrack? _currentTrack;
  Playlist? _currentPlaylist;
  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isRepeating = false;
  
  // Recently played
  List<MusicTrack> _recentlyPlayed = [];
  
  // Music challenges
  List<MusicChallenge> _activeChallenges = [];
  
  // Artist content
  List<ArtistInterview> _artistInterviews = [];
  List<BehindTheScenes> _behindTheScenes = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<MusicTrack> get featuredTracks => _featuredTracks;
  List<MusicTrack> get localTracks => _localTracks;
  List<MusicTrack> get favoriteTracks => _favoriteTracks;
  List<Playlist> get playlists => _playlists;
  List<MusicGenre> get genres => _genres;
  MusicTrack? get currentTrack => _currentTrack;
  Playlist? get currentPlaylist => _currentPlaylist;
  bool get isPlaying => _isPlaying;
  bool get isShuffled => _isShuffled;
  bool get isRepeating => _isRepeating;
  List<MusicTrack> get recentlyPlayed => _recentlyPlayed;
  List<MusicChallenge> get activeChallenges => _activeChallenges;
  List<ArtistInterview> get artistInterviews => _artistInterviews;
  List<BehindTheScenes> get behindTheScenes => _behindTheScenes;
  AudioPlayer get audioPlayer => _audioPlayer;

  // Initialize music data
  Future<void> initialize() async {
    await loadMusicData();
    await loadUserData();
    await loadArtistContent();
    await loadMusicChallenges();
  }

  // Load basic music data
  Future<void> loadMusicData() async {
    _setLoading(true);
    try {
      final results = await Future.wait([
        _musicService.getFeaturedTracks(),
        _musicService.getLocalTracks(),
        _musicService.getMusicGenres(),
        _musicService.getPlaylists(isFeatured: true),
      ]);

      _featuredTracks = results[0] as List<MusicTrack>;
      _localTracks = results[1] as List<MusicTrack>;
      _genres = results[2] as List<MusicGenre>;
      _playlists = results[3] as List<Playlist>;
      
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load user-specific data
  Future<void> loadUserData() async {
    try {
      _favoriteTracks = await _musicService.getFavoriteTracks();
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Load artist content (interviews, behind-the-scenes)
  Future<void> loadArtistContent() async {
    try {
      // TODO: Implement API calls for artist content
      _artistInterviews = _getMockArtistInterviews();
      _behindTheScenes = _getMockBehindTheScenes();
      notifyListeners();
    } catch (e) {
      print('Error loading artist content: $e');
    }
  }

  // Load music challenges
  Future<void> loadMusicChallenges() async {
    try {
      // TODO: Implement API calls for music challenges
      _activeChallenges = _getMockMusicChallenges();
      notifyListeners();
    } catch (e) {
      print('Error loading music challenges: $e');
    }
  }

  // Playback controls
  Future<void> playTrack(MusicTrack track, {Playlist? playlist}) async {
    try {
      await _audioPlayer.setUrl(track.fileUrl);
      _currentTrack = track;
      _currentPlaylist = playlist;
      _isPlaying = true;
      
      // Add to recently played
      _addToRecentlyPlayed(track);
      
      // Increment play count
      _musicService.incrementPlayCount(track.id);
      
      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      _setError('Failed to play track: $e');
    }
  }

  Future<void> pauseTrack() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> resumeTrack() async {
    await _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> stopTrack() async {
    await _audioPlayer.stop();
    _currentTrack = null;
    _isPlaying = false;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }

  // Favorites management
  Future<void> addToFavorites(MusicTrack track) async {
    try {
      await _musicService.addToFavorites(track.id);
      if (!_favoriteTracks.any((t) => t.id == track.id)) {
        _favoriteTracks.add(track);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(MusicTrack track) async {
    try {
      await _musicService.removeFromFavorites(track.id);
      _favoriteTracks.removeWhere((t) => t.id == track.id);
      notifyListeners();
    } catch (e) {
      _setError('Failed to remove from favorites: $e');
    }
  }

  bool isFavorite(MusicTrack track) {
    return _favoriteTracks.any((t) => t.id == track.id);
  }

  // Playlist management
  Future<void> createPlaylist(String name, {String? description}) async {
    try {
      final playlist = await _musicService.createPlaylist(
        name: name,
        description: description,
      );
      _playlists.add(playlist);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create playlist: $e');
    }
  }

  Future<void> addTrackToPlaylist(int playlistId, MusicTrack track) async {
    try {
      await _musicService.addTrackToPlaylist(playlistId, track.id);
      // Update local playlist if loaded
      final playlist = _playlists.firstWhere((p) => p.id == playlistId);
      // TODO: Refresh playlist tracks
      notifyListeners();
    } catch (e) {
      _setError('Failed to add track to playlist: $e');
    }
  }

  // Search functionality
  Future<List<MusicTrack>> searchTracks(String query) async {
    try {
      return await _musicService.searchTracks(query);
    } catch (e) {
      _setError('Search failed: $e');
      return [];
    }
  }

  // Get tracks by genre
  Future<List<MusicTrack>> getTracksByGenre(String genre) async {
    try {
      return await _musicService.getTracksByGenre(genre);
    } catch (e) {
      _setError('Failed to load genre tracks: $e');
      return [];
    }
  }

  // Music recommendations based on listening history
  List<MusicTrack> getRecommendations() {
    // Simple recommendation based on recently played genres
    if (_recentlyPlayed.isEmpty) return _featuredTracks.take(10).toList();
    
    final recentGenres = _recentlyPlayed.map((t) => t.genre).toSet();
    final recommendations = _localTracks.where((track) => 
      recentGenres.contains(track.genre) && 
      !_recentlyPlayed.any((r) => r.id == track.id)
    ).take(10).toList();
    
    return recommendations.isEmpty ? _featuredTracks.take(10).toList() : recommendations;
  }

  // Recently played management
  void _addToRecentlyPlayed(MusicTrack track) {
    _recentlyPlayed.removeWhere((t) => t.id == track.id);
    _recentlyPlayed.insert(0, track);
    if (_recentlyPlayed.length > 50) {
      _recentlyPlayed = _recentlyPlayed.take(50).toList();
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Mock data for artist content and challenges
  List<ArtistInterview> _getMockArtistInterviews() {
    return [
      ArtistInterview(
        id: 1,
        title: "Sauti Sol's Creative Journey",
        artist: "Sauti Sol",
        description: "Exclusive interview about their latest album and Kenyan music evolution",
        thumbnailUrl: "",
        videoUrl: "",
        duration: 1800, // 30 minutes
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        isLocal: true,
      ),
      ArtistInterview(
        id: 2,
        title: "Nyashinski on Gengetone Evolution",
        artist: "Nyashinski",
        description: "How Gengetone is shaping the future of Kenyan music",
        thumbnailUrl: "",
        videoUrl: "",
        duration: 1200,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        isLocal: true,
      ),
    ];
  }

  List<BehindTheScenes> _getMockBehindTheScenes() {
    return [
      BehindTheScenes(
        id: 1,
        title: "Studio Session: Recording 'Melanin'",
        artist: "Khaligraph Jones",
        description: "Behind-the-scenes footage from the recording of the hit track",
        thumbnailUrl: "",
        mediaUrls: [],
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        isLocal: true,
      ),
    ];
  }

  List<MusicChallenge> _getMockMusicChallenges() {
    return [
      MusicChallenge(
        id: 1,
        title: "Benga Dance Challenge",
        description: "Show us your best Benga dance moves!",
        hashtag: "#BengaDanceKE",
        prizeMoney: 10000,
        endDate: DateTime.now().add(const Duration(days: 14)),
        participantsCount: 245,
        isActive: true,
      ),
      MusicChallenge(
        id: 2,
        title: "Cover Song Competition",
        description: "Cover your favorite Kenyan song and win recording time!",
        hashtag: "#CoverSongKE",
        prizeMoney: 25000,
        endDate: DateTime.now().add(const Duration(days: 21)),
        participantsCount: 89,
        isActive: true,
      ),
    ];
  }
}

// Supporting classes for artist content and challenges
class ArtistInterview {
  final int id;
  final String title;
  final String artist;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final int duration;
  final DateTime publishedAt;
  final bool isLocal;

  ArtistInterview({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.publishedAt,
    required this.isLocal,
  });
}

class BehindTheScenes {
  final int id;
  final String title;
  final String artist;
  final String description;
  final String thumbnailUrl;
  final List<String> mediaUrls;
  final DateTime publishedAt;
  final bool isLocal;

  BehindTheScenes({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.thumbnailUrl,
    required this.mediaUrls,
    required this.publishedAt,
    required this.isLocal,
  });
}

class MusicChallenge {
  final int id;
  final String title;
  final String description;
  final String hashtag;
  final double prizeMoney;
  final DateTime endDate;
  final int participantsCount;
  final bool isActive;

  MusicChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.hashtag,
    required this.prizeMoney,
    required this.endDate,
    required this.participantsCount,
    required this.isActive,
  });

  String get prizeMoneyFormatted => 'KSh ${prizeMoney.toStringAsFixed(0)}';
  
  int get daysLeft => endDate.difference(DateTime.now()).inDays;
  
  String get timeLeftText {
    final days = daysLeft;
    if (days > 0) return '$days days left';
    return 'Ending soon';
  }
}
