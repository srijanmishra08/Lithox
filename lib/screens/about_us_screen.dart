import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../widgets/lithox_logo.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  late PageController _pageController;
  int _currentMediaIndex = 0;
  VideoPlayerController? _videoController;
  
  final List<MediaItem> _mediaItems = [
    MediaItem(
      type: MediaType.image,
      path: 'assets/images/Box.jpeg',
      title: 'Premium Epoxy Products',
      description: 'Our high-quality epoxy products ready for application',
    ),
    MediaItem(
      type: MediaType.image,
      path: 'assets/images/Floor1.jpeg',
      title: 'Professional Floor Installation',
      description: 'Expert application of epoxy flooring solutions',
    ),
    MediaItem(
      type: MediaType.image,
      path: 'assets/images/floor 2.jpeg',
      title: 'Finished Epoxy Flooring',
      description: 'Beautiful, durable epoxy flooring results',
    ),
    MediaItem(
      type: MediaType.video,
      path: 'assets/images/video1.mp4',
      title: 'Our Work in Action',
      description: 'See our professional epoxy application process',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom header with back button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            context.go('/');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'About Us',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Main content with padding
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Header with company tagline
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const LithoxLogo.large(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'LITHOX™ - A Legacy of Innovation Since 1994',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chemistry for Stones',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Company story section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.history,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Our Story',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Company description with improved readability
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Founded in 1994 by ',
                        ),
                        TextSpan(
                          text: 'visionary chemical engineer, Mr. Manish Jain',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ', an alumnus of ',
                        ),
                        TextSpan(
                          text: 'IIT Mumbai',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ', Lithox began its journey as a small-scale manufacturer with a big mission — to deliver world-class ',
                        ),
                        TextSpan(
                          text: 'epoxy solutions',
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ' tailored for India\'s growing industrial needs.\n\n',
                        ),
                        const TextSpan(
                          text: 'With a solid foundation in chemical engineering and hands-on experience at ',
                        ),
                        TextSpan(
                          text: 'Hindustan Zinc',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ' for two years, Mr. Manish Jain envisioned a company that would blend ',
                        ),
                        TextSpan(
                          text: 'technical precision, material innovation, and customer trust',
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: '.\n\nLithox quickly established itself as a trusted name in epoxy flooring, industrial coatings, and high-performance adhesives. Its commitment to quality and customization earned it the loyalty of clients across sectors like construction, infrastructure, stone processing, and manufacturing.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Media Gallery Section
            _buildMediaGallery(theme),
            
            const SizedBox(height: 32),
            
            // New generation section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.family_restroom,
                          color: theme.colorScheme.secondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'A New Generation of Leadership',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(
                          text: 'After decades of steady growth and technical refinement, in the 2010s, the management torch was passed to the next generation — sons, ',
                        ),
                        TextSpan(
                          text: 'Mr. Hritvik Jain',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ', an electronics engineer from ',
                        ),
                        TextSpan(
                          text: 'VIT Vellore',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ', and ',
                        ),
                        TextSpan(
                          text: 'Mr. Chinmay Jain',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ', a computer science engineer from ',
                        ),
                        TextSpan(
                          text: 'SRM University, Kattankulathur',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: '. Under their dynamic leadership, Lithox has expanded digitally, diversified product lines, and embraced ',
                        ),
                        TextSpan(
                          text: 'smart manufacturing',
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ', all while preserving the brand\'s core values of integrity, quality, and innovation.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Key achievements
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: Colors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Key Achievements',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  _buildAchievementItem(
                    context,
                    'Pan-India',
                    'Leading manufacturer and wholesaler across India',
                    Icons.location_on,
                    Colors.green,
                  ),
                  _buildAchievementItem(
                    context,
                    'World-Class',
                    'Quality solutions for diverse industrial applications',
                    Icons.star,
                    Colors.amber.shade700,
                  ),
                  _buildAchievementItem(
                    context,
                    'Technical Excellence',
                    'Founded and led by IIT Mumbai alumni',
                    Icons.school,
                    Colors.blue,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Vision and mission
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.visibility,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Our Vision',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'To be the leading innovator in epoxy-based solutions, transforming spaces across India with premium quality products that combine technical precision, material innovation, and unwavering customer trust.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.6,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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

  Widget _buildMediaGallery(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Our Work Gallery',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Explore our premium epoxy products and professional installations',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          
          // Media Carousel
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // PageView for media
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentMediaIndex = index;
                    });
                    _handleMediaChange(index);
                  },
                  itemCount: _mediaItems.length,
                  itemBuilder: (context, index) {
                    return _buildMediaItem(_mediaItems[index], theme);
                  },
                ),
                
                // Media indicators
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _mediaItems.asMap().entries.map((entry) {
                      return Container(
                        width: _currentMediaIndex == entry.key ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentMediaIndex == entry.key
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // Navigation arrows
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        onPressed: () {
                          if (_currentMediaIndex > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                        onPressed: () {
                          if (_currentMediaIndex < _mediaItems.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Current media info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.purple.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _mediaItems[_currentMediaIndex].title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _mediaItems[_currentMediaIndex].description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(MediaItem item, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: item.type == MediaType.image
            ? _buildImageWidget(item.path)
            : _buildVideoWidget(item.path),
      ),
    );
  }

  Widget _buildImageWidget(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50, color: Colors.grey),
                SizedBox(height: 8),
                Text('Image not found', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoWidget(String path) {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_videoController != null && _videoController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          else
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library, size: 50, color: Colors.white70),
                  SizedBox(height: 8),
                  Text(
                    'Loading video...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          
          // Play/Pause button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              iconSize: 40,
              icon: Icon(
                _videoController?.value.isPlaying == true
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                if (_videoController?.value.isPlaying == true) {
                  _videoController?.pause();
                } else {
                  _videoController?.play();
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleMediaChange(int index) {
    final item = _mediaItems[index];
    
    if (item.type == MediaType.video) {
      _initializeVideo(item.path);
    } else {
      // Dispose video controller when switching to image
      _videoController?.dispose();
      _videoController = null;
    }
  }

  void _initializeVideo(String path) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.asset(path)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        if (kDebugMode) {
          debugPrint('Video initialization error: $error');
        }
      });
  }

  Widget _buildAchievementItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
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

// Supporting classes for media gallery
enum MediaType { image, video }

class MediaItem {
  final MediaType type;
  final String path;
  final String title;
  final String description;

  MediaItem({
    required this.type,
    required this.path,
    required this.title,
    required this.description,
  });
}
