class User {
  final int id;
  final String name;
  final String email;
  final String? role;
  final DateTime? emailVerifiedAt;
  final Profile? profile;
  final int? profileMusicTrackId;
  final List<String>? favoriteGenres;
  final Map<String, dynamic>? musicPreferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.emailVerifiedAt,
    this.profile,
    this.profileMusicTrackId,
    this.favoriteGenres,
    this.musicPreferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      profile: json['profile'] != null 
          ? Profile.fromJson(json['profile'])
          : null,
      profileMusicTrackId: json['profile_music_track_id'],
      favoriteGenres: json['favorite_genres'] != null 
          ? List<String>.from(json['favorite_genres'])
          : null,
      musicPreferences: json['music_preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'profile': profile?.toJson(),
      'profile_music_track_id': profileMusicTrackId,
      'favorite_genres': favoriteGenres,
      'music_preferences': musicPreferences,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    DateTime? emailVerifiedAt,
    Profile? profile,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      profile: profile ?? this.profile,
    );
  }
}

class Profile {
  final int id;
  final int userId;
  final String? bio;
  final String? avatar;
  final String? location;
  final String? course;
  final String? year;

  Profile({
    required this.id,
    required this.userId,
    this.bio,
    this.avatar,
    this.location,
    this.course,
    this.year,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      bio: json['bio'],
      avatar: json['avatar'],
      location: json['location'],
      course: json['course'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bio': bio,
      'avatar': avatar,
      'location': location,
      'course': course,
      'year': year,
    };
  }
}
