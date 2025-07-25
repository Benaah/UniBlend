import 'user.dart';
import 'music_track.dart';

class Thread {
  final int id;
  final String title;
  final String content;
  final int authorId;
  final int? courseId;
  final int? clubId;
  final int? musicTrackId;
  final String? category;
  final String status;
  final bool isPinned;
  final bool isMusicRelated;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relationships
  final User? author;
  final Course? course;
  final Club? club;
  final MusicTrack? musicTrack;
  final int? postsCount;
  final int? viewsCount;

  Thread({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    this.courseId,
    this.clubId,
    this.musicTrackId,
    this.category,
    required this.status,
    required this.isPinned,
    required this.isMusicRelated,
    required this.createdAt,
    required this.updatedAt,
    this.author,
    this.course,
    this.club,
    this.musicTrack,
    this.postsCount,
    this.viewsCount,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorId: json['author_id'],
      courseId: json['course_id'],
      clubId: json['club_id'],
      musicTrackId: json['music_track_id'],
      category: json['category'],
      status: json['status'] ?? 'active',
      isPinned: json['is_pinned'] ?? false,
      isMusicRelated: json['is_music_related'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      author: json['author'] != null ? User.fromJson(json['author']) : null,
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      club: json['club'] != null ? Club.fromJson(json['club']) : null,
      musicTrack: json['music_track'] != null 
          ? MusicTrack.fromJson(json['music_track']) 
          : null,
      postsCount: json['posts_count'],
      viewsCount: json['views_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author_id': authorId,
      'course_id': courseId,
      'club_id': clubId,
      'music_track_id': musicTrackId,
      'category': category,
      'status': status,
      'is_pinned': isPinned,
      'is_music_related': isMusicRelated,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'posts_count': postsCount,
      'views_count': viewsCount,
    };
  }

  bool get hasMusic => musicTrackId != null;
  
  String get categoryDisplayName {
    switch (category?.toLowerCase()) {
      case 'music':
        return '🎵 Music';
      case 'academic':
        return '📚 Academic';
      case 'social':
        return '👥 Social';
      case 'events':
        return '🎉 Events';
      case 'general':
        return '💬 General';
      default:
        return category ?? '💬 General';
    }
  }

  String get statusDisplayName {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'flagged':
        return 'Flagged';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  Thread copyWith({
    int? id,
    String? title,
    String? content,
    int? authorId,
    int? courseId,
    int? clubId,
    int? musicTrackId,
    String? category,
    String? status,
    bool? isPinned,
    bool? isMusicRelated,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? author,
    Course? course,
    Club? club,
    MusicTrack? musicTrack,
    int? postsCount,
    int? viewsCount,
  }) {
    return Thread(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      courseId: courseId ?? this.courseId,
      clubId: clubId ?? this.clubId,
      musicTrackId: musicTrackId ?? this.musicTrackId,
      category: category ?? this.category,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      isMusicRelated: isMusicRelated ?? this.isMusicRelated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      course: course ?? this.course,
      club: club ?? this.club,
      musicTrack: musicTrack ?? this.musicTrack,
      postsCount: postsCount ?? this.postsCount,
      viewsCount: viewsCount ?? this.viewsCount,
    );
  }
}

class Course {
  final int id;
  final String name;
  final String? description;

  Course({
    required this.id,
    required this.name,
    this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

class Club {
  final int id;
  final String name;
  final String? description;

  Club({
    required this.id,
    required this.name,
    this.description,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

class ThreadPost {
  final int id;
  final int threadId;
  final int userId;
  final String content;
  final DateTime createdAt;
  final User? user;

  ThreadPost({
    required this.id,
    required this.threadId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.user,
  });

  factory ThreadPost.fromJson(Map<String, dynamic> json) {
    return ThreadPost(
      id: json['id'],
      threadId: json['thread_id'],
      userId: json['user_id'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thread_id': threadId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
