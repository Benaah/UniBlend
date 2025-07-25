import 'package:flutter/material.dart';
import '../../../shared/models/music_track.dart';
import '../../../shared/models/music_genre.dart';
import '../../../shared/models/playlist.dart';
import '../music_service.dart';
import '../widgets/music_track_card.dart';
import '../widgets/audio_player_widget.dart';

class MusicDiscoveryScreen extends StatefulWidget {
  const MusicDiscoveryScreen({Key? key}) : super(key: key);

  @override
  State<MusicDiscoveryScreen> createState() => _MusicDiscoveryScreenState();
}

class _MusicDiscoveryScreenState extends State<MusicDiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MusicService _musicService = MusicService();
  
  List<MusicTrack> _featuredTracks = [];
  List<MusicTrack> _localTracks = [];
  List<MusicGenre> _genres = [];
  List<Playlist> _featuredPlaylists = [];
  
  MusicTrack? _currentTrack;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMusicData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMusicData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _musicService.getFeaturedTracks(),
        _musicService.getLocalTracks(),
        _musicService.getMusicGenres(),
        _musicService.getPlaylists(isFeatured: true),
      ]);

      setState(() {
        _featuredTracks = results[0] as List<MusicTrack>;
        _localTracks = results[1] as List<MusicTrack>;
        _genres = results[2] as List<MusicGenre>;
        _featuredPlaylists = results[3] as List<Playlist>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover Music',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Featured'),
            Tab(text: 'Local'),
            Tab(text: 'Genres'),
            Tab(text: 'Playlists'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorWidget()
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildFeaturedTab(),
                          _buildLocalTab(),
                          _buildGenresTab(),
                          _buildPlaylistsTab(),
                        ],
                      ),
          ),
          if (_currentTrack != null)
            AudioPlayerWidget(
              track: _currentTrack!,
              isFullScreen: false,
              onClose: () => setState(() => _currentTrack = null),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load music',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadMusicData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedTab() {
    if (_featuredTracks.isEmpty) {
      return const Center(
        child: Text('No featured tracks available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMusicData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _featuredTracks.length,
        itemBuilder: (context, index) {
          final track = _featuredTracks[index];
          return MusicTrackCard(
            track: track,
            isPlaying: _currentTrack?.id == track.id,
            onPlay: () => _playTrack(track),
            onFavorite: () => _addToFavorites(track),
            onAddToPlaylist: () => _showAddToPlaylistDialog(track),
          );
        },
      ),
    );
  }

  Widget _buildLocalTab() {
    if (_localTracks.isEmpty) {
      return const Center(
        child: Text('No local tracks available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMusicData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _localTracks.length,
        itemBuilder: (context, index) {
          final track = _localTracks[index];
          return MusicTrackCard(
            track: track,
            isPlaying: _currentTrack?.id == track.id,
            onPlay: () => _playTrack(track),
            onFavorite: () => _addToFavorites(track),
            onAddToPlaylist: () => _showAddToPlaylistDialog(track),
          );
        },
      ),
    );
  }

  Widget _buildGenresTab() {
    if (_genres.isEmpty) {
      return const Center(
        child: Text('No genres available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMusicData,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _genres.length,
        itemBuilder: (context, index) {
          final genre = _genres[index];
          return _buildGenreCard(genre);
        },
      ),
    );
  }

  Widget _buildGenreCard(MusicGenre genre) {
    return Card(
      child: InkWell(
        onTap: () => _showGenreTracks(genre),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getGenreColor(genre.name),
                _getGenreColor(genre.name).withOpacity(0.7),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      genre.flagEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const Spacer(),
                    if (genre.isFeatured)
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 16,
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  genre.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (genre.tracksCount != null)
                  Text(
                    genre.tracksCountText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    if (_featuredPlaylists.isEmpty) {
      return const Center(
        child: Text('No playlists available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMusicData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _featuredPlaylists.length,
        itemBuilder: (context, index) {
          final playlist = _featuredPlaylists[index];
          return _buildPlaylistCard(playlist);
        },
      ),
    );
  }

  Widget _buildPlaylistCard(Playlist playlist) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.purple.shade100,
          ),
          child: playlist.coverImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    playlist.coverImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.queue_music,
                      color: Colors.purple.shade400,
                    ),
                  ),
                )
              : Icon(
                  Icons.queue_music,
                  color: Colors.purple.shade400,
                ),
        ),
        title: Text(
          playlist.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (playlist.description != null)
              Text(
                playlist.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              '${playlist.tracksCountText} • ${playlist.followersCountText}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (playlist.isFeatured)
              const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _showPlaylistTracks(playlist),
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

  void _playTrack(MusicTrack track) {
    setState(() {
      _currentTrack = track;
    });
    // TODO: Increment play count
    _musicService.incrementPlayCount(track.id);
  }

  void _addToFavorites(MusicTrack track) {
    _musicService.addToFavorites(track.id).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "${track.title}" to favorites'),
          duration: const Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to favorites: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _showAddToPlaylistDialog(MusicTrack track) {
    // TODO: Implement add to playlist dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add "${track.title}" to playlist feature coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Music'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter song, artist, or genre...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (query) {
            Navigator.of(context).pop();
            _searchMusic(query);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _searchMusic(String query) {
    // TODO: Implement search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for "$query"...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showGenreTracks(MusicGenre genre) {
    // TODO: Navigate to genre tracks screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing ${genre.name} tracks...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPlaylistTracks(Playlist playlist) {
    // TODO: Navigate to playlist tracks screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening "${playlist.name}" playlist...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
