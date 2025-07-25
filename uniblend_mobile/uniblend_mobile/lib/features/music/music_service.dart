import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../../shared/models/music_track.dart';
import '../../shared/models/playlist.dart';
import '../../shared/models/music_genre.dart';

class MusicService {
  static const String _baseUrl = ApiConfig.baseUrl;
  
  Future<Map<String, String>> _getHeaders() async {
    // TODO: Implement token retrieval from secure storage
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    };
  }

  // Music Tracks
  Future<List<MusicTrack>> getMusicTracks({
    String? genre,
    bool? isLocal,
    bool? isFeatured,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{};
    if (genre != null) queryParams['genre'] = genre;
    if (isLocal != null) queryParams['is_local'] = isLocal.toString();
    if (isFeatured != null) queryParams['is_featured'] = isFeatured.toString();
    if (search != null) queryParams['search'] = search;
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    final uri = Uri.parse('$_baseUrl${ApiConfig.musicTracksEndpoint}')
        .replace(queryParameters: queryParams);
    
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> tracksJson = jsonData['data'] ?? jsonData;
      return tracksJson.map((track) => MusicTrack.fromJson(track)).toList();
    } else {
      throw Exception('Failed to load music tracks: ${response.statusCode}');
    }
  }

  Future<MusicTrack> getMusicTrack(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl${ApiConfig.musicTracksEndpoint}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return MusicTrack.fromJson(jsonData['data'] ?? jsonData);
    } else {
      throw Exception('Failed to load music track: ${response.statusCode}');
    }
  }

  Future<List<MusicTrack>> getFeaturedTracks() async {
    return getMusicTracks(isFeatured: true, limit: 20);
  }

  Future<List<MusicTrack>> getLocalTracks() async {
    return getMusicTracks(isLocal: true, limit: 50);
  }

  Future<List<MusicTrack>> searchTracks(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl${ApiConfig.searchMusicEndpoint}?q=$query'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> tracksJson = jsonData['data'] ?? jsonData;
      return tracksJson.map((track) => MusicTrack.fromJson(track)).toList();
    } else {
      throw Exception('Failed to search tracks: ${response.statusCode}');
    }
  }

  // Playlists
  Future<List<Playlist>> getPlaylists({
    bool? isPublic,
    bool? isFeatured,
    int? userId,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String>{};
    if (isPublic != null) queryParams['is_public'] = isPublic.toString();
    if (isFeatured != null) queryParams['is_featured'] = isFeatured.toString();
    if (userId != null) queryParams['user_id'] = userId.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    final uri = Uri.parse('$_baseUrl${ApiConfig.playlistsEndpoint}')
        .replace(queryParameters: queryParams);
    
    final response = await http.get(uri, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> playlistsJson = jsonData['data'] ?? jsonData;
      return playlistsJson.map((playlist) => Playlist.fromJson(playlist)).toList();
    } else {
      throw Exception('Failed to load playlists: ${response.statusCode}');
    }
  }

  Future<Playlist> getPlaylist(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl${ApiConfig.playlistsEndpoint}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Playlist.fromJson(jsonData['data'] ?? jsonData);
    } else {
      throw Exception('Failed to load playlist: ${response.statusCode}');
    }
  }

  Future<Playlist> createPlaylist({
    required String name,
    String? description,
    bool isPublic = true,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl${ApiConfig.playlistsEndpoint}'),
      headers: await _getHeaders(),
      body: json.encode({
        'name': name,
        'description': description,
        'is_public': isPublic,
      }),
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return Playlist.fromJson(jsonData['data'] ?? jsonData);
    } else {
      throw Exception('Failed to create playlist: ${response.statusCode}');
    }
  }

  Future<void> addTrackToPlaylist(int playlistId, int trackId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl${ApiConfig.playlistsEndpoint}/$playlistId/tracks'),
      headers: await _getHeaders(),
      body: json.encode({'track_id': trackId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add track to playlist: ${response.statusCode}');
    }
  }

  Future<void> removeTrackFromPlaylist(int playlistId, int trackId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl${ApiConfig.playlistsEndpoint}/$playlistId/tracks/$trackId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove track from playlist: ${response.statusCode}');
    }
  }

  // Music Genres
  Future<List<MusicGenre>> getMusicGenres() async {
    final response = await http.get(
      Uri.parse('$_baseUrl${ApiConfig.musicGenresEndpoint}'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> genresJson = jsonData['data'] ?? jsonData;
      return genresJson.map((genre) => MusicGenre.fromJson(genre)).toList();
    } else {
      throw Exception('Failed to load music genres: ${response.statusCode}');
    }
  }

  Future<List<MusicTrack>> getTracksByGenre(String genreName) async {
    return getMusicTracks(genre: genreName);
  }

  // Favorites
  Future<List<MusicTrack>> getFavoriteTracks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl${ApiConfig.favoritesEndpoint}'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> tracksJson = jsonData['data'] ?? jsonData;
      return tracksJson.map((track) => MusicTrack.fromJson(track)).toList();
    } else {
      throw Exception('Failed to load favorite tracks: ${response.statusCode}');
    }
  }

  Future<void> addToFavorites(int trackId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl${ApiConfig.favoritesEndpoint}'),
      headers: await _getHeaders(),
      body: json.encode({'track_id': trackId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to favorites: ${response.statusCode}');
    }
  }

  Future<void> removeFromFavorites(int trackId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl${ApiConfig.favoritesEndpoint}/$trackId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites: ${response.statusCode}');
    }
  }

  // Analytics
  Future<void> incrementPlayCount(int trackId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl${ApiConfig.musicTracksEndpoint}/$trackId/play'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      // Silently fail for analytics - don't throw exception
      print('Failed to increment play count: ${response.statusCode}');
    }
  }
}
