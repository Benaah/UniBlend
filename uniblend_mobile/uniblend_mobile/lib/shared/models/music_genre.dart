class MusicGenre {
  final int id;
  final String name;
  final String? description;
  final String? coverImage;
  final bool isLocal;
  final bool isFeatured;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Additional properties
  final int? tracksCount;

  MusicGenre({
    required this.id,
    required this.name,
    this.description,
    this.coverImage,
    required this.isLocal,
    required this.isFeatured,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.tracksCount,
  });

  factory MusicGenre.fromJson(Map<String, dynamic> json) {
    return MusicGenre(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      coverImage: json['cover_image'],
      isLocal: json['is_local'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      tracksCount: json['tracks_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cover_image': coverImage,
      'is_local': isLocal,
      'is_featured': isFeatured,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'tracks_count': tracksCount,
    };
  }

  String get flagEmoji {
    if (isLocal) return '🇰🇪';
    return '🌍';
  }

  String get tracksCountText {
    if (tracksCount == null) return '';
    return '${tracksCount} track${tracksCount! == 1 ? '' : 's'}';
  }

  // Predefined Kenyan music genres with their typical characteristics
  static List<MusicGenre> get kenyanGenres => [
    MusicGenre(
      id: 1,
      name: 'Benga',
      description: 'Traditional Kenyan music style characterized by clear guitar melodies',
      isLocal: true,
      isFeatured: true,
      sortOrder: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MusicGenre(
      id: 2,
      name: 'Genge',
      description: 'Kenyan hip-hop and rap music popular among youth',
      isLocal: true,
      isFeatured: true,
      sortOrder: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MusicGenre(
      id: 3,
      name: 'Afrobeat',
      description: 'Modern African music blending traditional and contemporary sounds',
      isLocal: true,
      isFeatured: true,
      sortOrder: 3,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MusicGenre(
      id: 4,
      name: 'Gospel',
      description: 'Christian music with strong spiritual messages',
      isLocal: true,
      isFeatured: false,
      sortOrder: 4,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}
