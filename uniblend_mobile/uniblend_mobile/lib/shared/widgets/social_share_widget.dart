import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes/kenyan_theme.dart';

class SocialShareWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final String shareUrl;
  final String hashtag;

  const SocialShareWidget({
    Key? key,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.shareUrl,
    required this.hashtag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share This Track',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Preview card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      if (imageUrl != null)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade300,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.music_note,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      if (imageUrl != null) const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Hashtag
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KenyanTheme.kenyanGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KenyanTheme.kenyanGreen.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          hashtag,
                          style: TextStyle(
                            color: KenyanTheme.kenyanGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _copyToClipboard(context, hashtag),
                        icon: Icon(
                          Icons.copy,
                          color: KenyanTheme.kenyanGreen,
                        ),
                        tooltip: 'Copy hashtag',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Social media platforms
                Text(
                  'Share on:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Social buttons grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildSocialButton(
                      context,
                      'WhatsApp',
                      Icons.chat,
                      Colors.green,
                      () => _shareToWhatsApp(),
                    ),
                    _buildSocialButton(
                      context,
                      'Twitter',
                      Icons.alternate_email,
                      Colors.blue,
                      () => _shareToTwitter(),
                    ),
                    _buildSocialButton(
                      context,
                      'Facebook',
                      Icons.facebook,
                      const Color(0xFF1877F2),
                      () => _shareToFacebook(),
                    ),
                    _buildSocialButton(
                      context,
                      'Instagram',
                      Icons.camera_alt,
                      Colors.purple,
                      () => _shareToInstagram(),
                    ),
                    _buildSocialButton(
                      context,
                      'TikTok',
                      Icons.music_video,
                      Colors.black,
                      () => _shareToTikTok(),
                    ),
                    _buildSocialButton(
                      context,
                      'Telegram',
                      Icons.send,
                      const Color(0xFF0088CC),
                      () => _shareToTelegram(),
                    ),
                    _buildSocialButton(
                      context,
                      'SMS',
                      Icons.sms,
                      Colors.orange,
                      () => _shareViaSMS(),
                    ),
                    _buildSocialButton(
                      context,
                      'More',
                      Icons.more_horiz,
                      Colors.grey,
                      () => _shareMore(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Copy link button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(context, shareUrl),
                    icon: const Icon(Icons.link),
                    label: const Text('Copy Link'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: KenyanTheme.kenyanGreen),
                      foregroundColor: KenyanTheme.kenyanGreen,
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

  Widget _buildSocialButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
        duration: const Duration(seconds: 2),
        backgroundColor: KenyanTheme.kenyanGreen,
      ),
    );
  }

  String get _shareText {
    return '$title\n\n$description\n\n$hashtag\n\nListen on UniBlend: $shareUrl';
  }

  void _shareToWhatsApp() {
    // TODO: Implement WhatsApp sharing
    print('Sharing to WhatsApp: $_shareText');
  }

  void _shareToTwitter() {
    // TODO: Implement Twitter sharing
    print('Sharing to Twitter: $_shareText');
  }

  void _shareToFacebook() {
    // TODO: Implement Facebook sharing
    print('Sharing to Facebook: $_shareText');
  }

  void _shareToInstagram() {
    // TODO: Implement Instagram sharing (typically requires story sharing)
    print('Sharing to Instagram: $_shareText');
  }

  void _shareToTikTok() {
    // TODO: Implement TikTok sharing
    print('Sharing to TikTok: $_shareText');
  }

  void _shareToTelegram() {
    // TODO: Implement Telegram sharing
    print('Sharing to Telegram: $_shareText');
  }

  void _shareViaSMS() {
    // TODO: Implement SMS sharing
    print('Sharing via SMS: $_shareText');
  }

  void _shareMore() {
    // TODO: Implement system share sheet
    print('Opening system share sheet: $_shareText');
  }

  static void show(
    BuildContext context, {
    required String title,
    required String description,
    String? imageUrl,
    required String shareUrl,
    required String hashtag,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SocialShareWidget(
        title: title,
        description: description,
        imageUrl: imageUrl,
        shareUrl: shareUrl,
        hashtag: hashtag,
      ),
    );
  }
}

// Kenyan social media sharing messages with local context
class KenyanShareMessages {
  static String getMusicTrackMessage(String title, String artist, String genre) {
    final greetings = [
      'Mambo vipi! 🇰🇪',
      'Niaje! 🇰🇪',
      'Sema! 🇰🇪',
      'Habari za leo! 🇰🇪',
    ];
    
    final endings = [
      'Usiulize! 🔥',
      'Hapo sawa! 👌',
      'Poa sana! 🎵',
      'Cheki hii! 🎶',
    ];
    
    final greeting = (greetings..shuffle()).first;
    final ending = (endings..shuffle()).first;
    
    return '$greeting Check out this amazing $genre track "$title" by $artist! $ending';
  }

  static String getPlaylistMessage(String playlistName, int trackCount) {
    return 'Just discovered this fire playlist "$playlistName" with $trackCount tracks! 🎵🇰🇪 Perfect vibes for today! #KenyanMusic #UniBlend';
  }

  static String getChallengeMessage(String challengeName, String hashtag) {
    return 'Join me in the $challengeName! Show your talent and win amazing prizes! 🏆🇰🇪 $hashtag #KenyanTalent #MusicChallenge';
  }

  static String getArtistInterviewMessage(String artistName, String title) {
    return 'Don\'t miss this exclusive interview with $artistName: "$title" 🎤🇰🇪 So much inspiration! #KenyanArtist #MusicInterview';
  }
}
