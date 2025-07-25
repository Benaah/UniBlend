class MusicTrack {
  final int id;
  final String title;
  final String artist;
  final String? album;
  final String? genre;
  final int? duration;
  final String fileUrl;
  final String? coverImage;
  final DateTime? releaseDate;
  final String language;
  final String country;
  final String? lyrics;
  final bool isLocal;
  final bool isFeatured;
  final int playCount;
  final String status;
  final int? uploadedBy;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.genre,
    this.duration,
    required this.fileUrl,
    this.coverImage,
    this.releaseDate,
    required this.language,
    required this.country,
    this.lyrics,
    required this.isLocal,
    required this.isFeatured,
    required this.playCount,
    required this.status,
    this.uploadedBy,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      genre: json['genre'],
      duration: json['duration'],
      fileUrl: json['file_url'],
      coverImage: json['cover_image'],
      releaseDate: json['release_date'] != null 
          ? DateTime.parse(json['release_date']) 
          : null,
      language: json['language'] ?? 'en',
      country: json['country'] ?? 'KE',
      lyrics: json['lyrics'],
      isLocal: json['is_local'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      playCount: json['play_count'] ?? 0,
      status: json['status'] ?? 'active',
      uploadedBy: json['uploaded_by'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'genre': genre,
      'duration': duration,
      'file_url': fileUrl,
      'cover_image': coverImage,
      'release_date': releaseDate?.toIso8601String(),
      'language': language,
      'country': country,
      'lyrics': lyrics,
      'is_local': isLocal,
      'is_featured': isFeatured,
      'play_count': playCount,
      'status': status,
      'uploaded_by': uploadedBy,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get durationFormatted {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  String get flagEmoji {
    switch (country) {
      case 'KE':
        return '🇰🇪';
      case 'TZ':
        return '🇹🇿';
      case 'UG':
        return '🇺🇬';
      case 'RW':
        return '🇷🇼';
      default:
        return '🌍';
    }
  }

  String get genreDisplayName {
    switch (genre?.toLowerCase()) {
      case 'afrobeat':
        return 'Afrobeat';
      case 'benga':
        return 'Benga';
      case 'genge':
        return 'Genge';
      case 'gospel':
        return 'Gospel';
      case 'hip hop':
        return 'Hip Hop';
      case 'r&b':
        return 'R&B';
      case 'reggae':
        return 'Reggae';
      case 'traditional':
        return 'Traditional';
      default:
        return genre ?? 'Unknown';
    }
  }
}
