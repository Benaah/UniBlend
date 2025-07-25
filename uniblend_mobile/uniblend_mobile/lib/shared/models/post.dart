import 'user.dart';
import 'music_track.dart';

class Post {
  final int id;
  final String caption;
  final List<String>? images;
  final List<String>? videos;
  final int userId;
  final int? musicTrackId;
  final int? musicStartTime;
  final int? musicEndTime;
  final String status;
  final bool isFeatured;
  final bool allowComments;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relationships
  final User? user;
  final MusicTrack? musicTrack;
  final int? likesCount;
  final int? commentsCount;
  final bool? isLiked;

  Post({
    required this.id,
    required this.caption,
    this.images,
    this.videos,
    required this.userId,
    this.musicTrackId,
    this.musicStartTime,
    this.musicEndTime,
    required this.status,
    required this.isFeatured,
    required this.allowComments,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.musicTrack,
    this.likesCount,
    this.commentsCount,
    this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      caption: json['caption'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      videos: json['videos'] != null ? List<String>.from(json['videos']) : null,
      userId: json['user_id'],
      musicTrackId: json['music_track_id'],
      musicStartTime: json['music_start_time'],
      musicEndTime: json['music_end_time'],
      status: json['status'] ?? 'published',
      isFeatured: json['is_featured'] ?? false,
      allowComments: json['allow_comments'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      musicTrack: json['music_track'] != null 
          ? MusicTrack.fromJson(json['music_track']) 
          : null,
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      isLiked: json['is_liked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caption': caption,
      'images': images,
      'videos': videos,
      'user_id': userId,
      'music_track_id': musicTrackId,
      'music_start_time': musicStartTime,
      'music_end_time': musicEndTime,
      'status': status,
      'is_featured': isFeatured,
      'allow_comments': allowComments,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'is_liked': isLiked,
    };
  }

  bool get hasMedia => (images?.isNotEmpty ?? false) || (videos?.isNotEmpty ?? false);
  bool get hasMusic => musicTrackId != null;
  bool get hasImages => images?.isNotEmpty ?? false;
  bool get hasVideos => videos?.isNotEmpty ?? false;

  String get musicDurationText {
    if (musicStartTime == null || musicEndTime == null) return '';
    final start = Duration(seconds: musicStartTime!);
    final end = Duration(seconds: musicEndTime!);
    return '${_formatDuration(start)} - ${_formatDuration(end)}';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  Post copyWith({
    int? id,
    String? caption,
    List<String>? images,
    List<String>? videos,
    int? userId,
    int? musicTrackId,
    int? musicStartTime,
    int? musicEndTime,
    String? status,
    bool? isFeatured,
    bool? allowComments,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    MusicTrack? musicTrack,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      userId: userId ?? this.userId,
      musicTrackId: musicTrackId ?? this.musicTrackId,
      musicStartTime: musicStartTime ?? this.musicStartTime,
      musicEndTime: musicEndTime ?? this.musicEndTime,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      allowComments: allowComments ?? this.allowComments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      musicTrack: musicTrack ?? this.musicTrack,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class PostComment {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final DateTime createdAt;
  final User? user;

  PostComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.user,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
