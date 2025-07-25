import 'music_track.dart';
import 'user.dart';

class Playlist {
  final int id;
  final String name;
  final String? description;
  final String? coverImage;
  final int userId;
  final bool isPublic;
  final bool isFeatured;
  final int playCount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relationships
  final User? user;
  final List<MusicTrack>? tracks;
  final int? tracksCount;
  final int? followersCount;
  final int? totalDuration;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    this.coverImage,
    required this.userId,
    required this.isPublic,
    required this.isFeatured,
    required this.playCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.tracks,
    this.tracksCount,
    this.followersCount,
    this.totalDuration,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      coverImage: json['cover_image'],
      userId: json['user_id'],
      isPublic: json['is_public'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      playCount: json['play_count'] ?? 0,
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      tracks: json['tracks'] != null 
          ? (json['tracks'] as List).map((track) => MusicTrack.fromJson(track)).toList()
          : null,
      tracksCount: json['tracks_count'],
      followersCount: json['followers_count'],
      totalDuration: json['total_duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cover_image': coverImage,
      'user_id': userId,
      'is_public': isPublic,
      'is_featured': isFeatured,
      'play_count': playCount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'tracks_count': tracksCount,
      'followers_count': followersCount,
      'total_duration': totalDuration,
    };
  }

  String get durationFormatted {
    if (totalDuration == null) return '';
    final minutes = totalDuration! ~/ 60;
    final seconds = totalDuration! % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  String get tracksCountText {
    if (tracksCount == null) return '';
    return '${tracksCount} track${tracksCount! == 1 ? '' : 's'}';
  }

  String get followersCountText {
    if (followersCount == null) return '';
    return '${followersCount} follower${followersCount! == 1 ? '' : 's'}';
  }
}
