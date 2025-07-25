import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/models/music_track.dart';

class MusicTrackCard extends StatelessWidget {
  final MusicTrack track;
  final VoidCallback? onTap;
  final VoidCallback? onPlay;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToPlaylist;
  final bool showFavoriteButton;
  final bool isPlaying;

  const MusicTrackCard({
    Key? key,
    required this.track,
    this.onTap,
    this.onPlay,
    this.onFavorite,
    this.onAddToPlaylist,
    this.showFavoriteButton = true,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap ?? onPlay,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Album Art
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: track.coverImage != null
                          ? CachedNetworkImage(
                              imageUrl: track.coverImage!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ),
                    ),
                  ),
                  if (isPlaying)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.pause,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: 12),
              
              // Track Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            track.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (track.isLocal)
                          Text(
                            track.flagEmoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (track.isFeatured)
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      track.artist,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (track.genre != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getGenreColor(track.genre!).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              track.genreDisplayName,
                              style: TextStyle(
                                color: _getGenreColor(track.genre!),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (track.duration != null)
                          Text(
                            track.durationFormatted,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showFavoriteButton)
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: onFavorite,
                      iconSize: 20,
                      color: Colors.grey.shade600,
                    ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: onPlay,
                    iconSize: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, size: 20, color: Colors.grey.shade600),
                    onSelected: (value) {
                      switch (value) {
                        case 'playlist':
                          onAddToPlaylist?.call();
                          break;
                        case 'share':
                          _shareTrack(context);
                          break;
                        case 'info':
                          _showTrackInfo(context);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'playlist',
                        child: Row(
                          children: [
                            Icon(Icons.playlist_add, size: 16),
                            SizedBox(width: 8),
                            Text('Add to Playlist'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, size: 16),
                            SizedBox(width: 8),
                            Text('Share'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'info',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16),
                            SizedBox(width: 8),
                            Text('Track Info'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getGenreColor(String genre) {
    switch (genre.toLowerCase()) {
      case 'afrobeat':
        return Colors.orange;
      case 'benga':
        return Colors.green;
      case 'genge':
        return Colors.purple;
      case 'gospel':
        return Colors.blue;
      case 'hip hop':
        return Colors.red;
      case 'r&b':
        return Colors.pink;
      case 'reggae':
        return Colors.amber;
      case 'traditional':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  void _shareTrack(BuildContext context) {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${track.title}" by ${track.artist}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showTrackInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(track.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Artist', track.artist),
            if (track.album != null) _buildInfoRow('Album', track.album!),
            if (track.genre != null) _buildInfoRow('Genre', track.genreDisplayName),
            if (track.duration != null) _buildInfoRow('Duration', track.durationFormatted),
            _buildInfoRow('Language', track.language.toUpperCase()),
            _buildInfoRow('Country', '${track.flagEmoji} ${track.country}'),
            _buildInfoRow('Plays', track.playCount.toString()),
            if (track.releaseDate != null)
              _buildInfoRow('Released', track.releaseDate!.year.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
