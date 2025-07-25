import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../../../core/themes/kenyan_theme.dart';

class MusicChallengesScreen extends StatefulWidget {
  const MusicChallengesScreen({Key? key}) : super(key: key);

  @override
  State<MusicChallengesScreen> createState() => _MusicChallengesScreenState();
}

class _MusicChallengesScreenState extends State<MusicChallengesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Challenges'),
        backgroundColor: KenyanTheme.kenyanGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateChallengeDialog(),
          ),
        ],
      ),
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          final challenges = musicProvider.activeChallenges;

          if (challenges.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => musicProvider.loadMusicChallenges(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return _buildChallengeCard(challenge);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showHowToParticipateDialog(),
        backgroundColor: KenyanTheme.kenyanGreen,
        icon: const Icon(Icons.help_outline, color: Colors.white),
        label: const Text(
          'How to Participate',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(MusicChallenge challenge) {
    final isEndingSoon = challenge.daysLeft <= 3;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: _getChallengeGradient(challenge.id),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        challenge.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        challenge.timeLeftText,
                        style: TextStyle(
                          color: isEndingSoon ? Colors.yellow.shade300 : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      challenge.prizeMoneyFormatted,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${challenge.participantsCount} participants',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Hashtag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: KenyanTheme.kenyanGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    challenge.hashtag,
                    style: TextStyle(
                      color: KenyanTheme.kenyanGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _participateInChallenge(challenge),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Participate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KenyanTheme.kenyanGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => _viewChallengeEntries(challenge),
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Entries'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: KenyanTheme.kenyanGreen),
                        foregroundColor: KenyanTheme.kenyanGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Share button
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => _shareChallenge(challenge),
                    icon: const Icon(Icons.share),
                    label: const Text('Share Challenge'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: KenyanTheme.kenyanSunset,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Active Challenges',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'New music challenges are coming soon!\nBe the first to know when they launch.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _suggestChallenge(),
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('Suggest a Challenge'),
              style: ElevatedButton.styleFrom(
                backgroundColor: KenyanTheme.kenyanGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getChallengeGradient(int challengeId) {
    switch (challengeId % 4) {
      case 1:
        return LinearGradient(
          colors: [KenyanTheme.bengaGreen, KenyanTheme.kenyanGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [KenyanTheme.afrobeatOrange, KenyanTheme.sunsetOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return LinearGradient(
          colors: [KenyanTheme.gospelPurple, KenyanTheme.kenyanRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [KenyanTheme.gengeBlue, KenyanTheme.lakeBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  void _participateInChallenge(MusicChallenge challenge) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                'Participate in ${challenge.title}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'How to participate:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: KenyanTheme.kenyanGreen,
                ),
              ),
              const SizedBox(height: 12),
              
              const _ParticipationStep(
                number: '1',
                title: 'Create your content',
                description: 'Record your video, photo, or audio according to the challenge theme',
              ),
              const _ParticipationStep(
                number: '2',
                title: 'Use the hashtag',
                description: 'Include the challenge hashtag in your post',
              ),
              const _ParticipationStep(
                number: '3',
                title: 'Share on social media',
                description: 'Post to your favorite social platforms and tag friends',
              ),
              const _ParticipationStep(
                number: '4',
                title: 'Submit to UniBlend',
                description: 'Upload your entry directly to the app',
              ),
              
              const Spacer(),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Maybe Later'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _openCameraForChallenge(challenge);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KenyanTheme.kenyanGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Start Creating'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewChallengeEntries(MusicChallenge challenge) {
    // TODO: Navigate to challenge entries screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing entries for ${challenge.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareChallenge(MusicChallenge challenge) {
    // TODO: Implement social sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${challenge.title}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openCameraForChallenge(MusicChallenge challenge) {
    // TODO: Open camera/video recorder for challenge submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening camera for ${challenge.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCreateChallengeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suggest a Challenge'),
        content: const Text(
          'Want to create your own music challenge? Send us your ideas and we might feature them in the app!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _suggestChallenge();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: KenyanTheme.kenyanGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Suggestion'),
          ),
        ],
      ),
    );
  }

  void _showHowToParticipateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: KenyanTheme.kenyanGreen),
            const SizedBox(width: 12),
            const Text('How to Participate'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Music challenges are fun competitions where you can:\n\n'
              '• Show off your musical talents\n'
              '• Win amazing prizes\n'
              '• Connect with other music lovers\n'
              '• Get featured on UniBlend\n\n'
              'Simply choose a challenge, create your content, and share it with the community!',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: KenyanTheme.kenyanGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _suggestChallenge() {
    // TODO: Implement challenge suggestion feature
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Challenge suggestion feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _ParticipationStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _ParticipationStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: KenyanTheme.kenyanGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
