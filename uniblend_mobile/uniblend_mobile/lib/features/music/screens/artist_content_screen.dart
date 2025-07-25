import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/music_provider.dart';
import '../../../core/themes/kenyan_theme.dart';

class ArtistContentScreen extends StatefulWidget {
  const ArtistContentScreen({Key? key}) : super(key: key);

  @override
  State<ArtistContentScreen> createState() => _ArtistContentScreenState();
}

class _ArtistContentScreenState extends State<ArtistContentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverFillRemaining(
                child: Column(
                  children: [
                    _buildTabBar(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildInterviewsTab(musicProvider),
                          _buildBehindTheScenesTab(musicProvider),
                          _buildMusicNewsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Artist Content',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: KenyanTheme.kenyanSunset,
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: 50,
                child: Icon(
                  Icons.music_note,
                  size: 150,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              Positioned(
                left: -30,
                bottom: 30,
                child: Icon(
                  Icons.mic,
                  size: 100,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: _tabController,
        indicatorColor: KenyanTheme.kenyanGreen,
        labelColor: KenyanTheme.kenyanGreen,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: 'Interviews'),
          Tab(text: 'Behind Scenes'),
          Tab(text: 'Music News'),
        ],
      ),
    );
  }

  Widget _buildInterviewsTab(MusicProvider musicProvider) {
    final interviews = musicProvider.artistInterviews;

    if (interviews.isEmpty) {
      return _buildEmptyState(
        icon: Icons.record_voice_over,
        title: 'No Interviews Yet',
        subtitle: 'Check back soon for exclusive artist interviews',
      );
    }

    return RefreshIndicator(
      onRefresh: () => musicProvider.loadArtistContent(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: interviews.length,
        itemBuilder: (context, index) {
          final interview = interviews[index];
          return _buildInterviewCard(interview);
        },
      ),
    );
  }

  Widget _buildInterviewCard(ArtistInterview interview) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _playInterview(interview),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          KenyanTheme.kenyanGreen,
                          KenyanTheme.kenyanGreen.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: interview.thumbnailUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: interview.thumbnailUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Icon(
                                Icons.record_voice_over,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.record_voice_over,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          interview.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          interview.artist,
                          style: TextStyle(
                            fontSize: 14,
                            color: KenyanTheme.kenyanGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (interview.isLocal)
                    const Text('🇰🇪', style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                interview.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(interview.duration),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(interview.publishedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.play_circle_filled,
                    color: KenyanTheme.kenyanGreen,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBehindTheScenesTab(MusicProvider musicProvider) {
    final behindScenes = musicProvider.behindTheScenes;

    if (behindScenes.isEmpty) {
      return _buildEmptyState(
        icon: Icons.video_camera_back,
        title: 'No Behind-the-Scenes Content',
        subtitle: 'Exclusive studio content coming soon',
      );
    }

    return RefreshIndicator(
      onRefresh: () => musicProvider.loadArtistContent(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: behindScenes.length,
        itemBuilder: (context, index) {
          final content = behindScenes[index];
          return _buildBehindScenesCard(content);
        },
      ),
    );
  }

  Widget _buildBehindScenesCard(BehindTheScenes content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _viewBehindScenes(content),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: LinearGradient(
                  colors: [
                    KenyanTheme.afrobeatOrange,
                    KenyanTheme.afrobeatOrange.withOpacity(0.7),
                  ],
                ),
              ),
              child: content.thumbnailUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: content.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: Icon(
                            Icons.video_camera_back,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.video_camera_back,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          content.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (content.isLocal)
                        const Text('🇰🇪', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content.artist,
                    style: TextStyle(
                      fontSize: 14,
                      color: KenyanTheme.afrobeatOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(content.publishedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicNewsTab() {
    // Mock news data - in real app, this would come from API
    final newsItems = [
      {
        'title': 'Kenyan Music Week 2024 Announced',
        'summary': 'The biggest celebration of Kenyan music returns this December with over 100 local artists',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'category': 'Events',
      },
      {
        'title': 'Benga Revival Movement Gains Momentum',
        'summary': 'Young artists are bringing traditional Benga music to the modern generation',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'category': 'Trends',
      },
      {
        'title': 'New Recording Studio Opens in Nairobi',
        'summary': 'State-of-the-art facility aims to support emerging Kenyan artists',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'category': 'Industry',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: newsItems.length,
      itemBuilder: (context, index) {
        final news = newsItems[index];
        return _buildNewsCard(news);
      },
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: KenyanTheme.getGenreColor('afrobeat').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    news['category'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: KenyanTheme.getGenreColor('afrobeat'),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(news['date'] as DateTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              news['title'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              news['summary'] as String,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  void _playInterview(ArtistInterview interview) {
    // TODO: Implement interview playback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${interview.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewBehindScenes(BehindTheScenes content) {
    // TODO: Implement behind-the-scenes content viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing: ${content.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
