//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:visibility_detector/visibility_detector.dart';
//
//
// import 'package:get/get.dart';
// import '../controllers/reel_controller.dart';
// import 'bottom_nav_bar.dart';
//
//
//
// class VideoFeedScreen extends StatelessWidget {
//   const VideoFeedScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final ReelController reelController = Get.find();
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Obx(() {
//         if (reelController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (reelController.videos.isEmpty) {
//           return const Center(
//             child: Text('No videos yet', style: TextStyle(color: Colors.white)),
//           );
//         }
//
//         return PageView.builder(
//           scrollDirection: Axis.vertical,
//           itemCount: reelController.videos.length,
//           itemBuilder: (context, index) {
//             return VideoReel(doc: reelController.videos[index]);
//           },
//         );
//       }),
//       bottomNavigationBar: BottomNavBar(),
//     );
//   }
// }
//
//
// class VideoReel extends StatefulWidget {
//   final DocumentSnapshot doc;
//
//   const VideoReel({super.key, required this.doc});
//
//   @override
//   State<VideoReel> createState() => _VideoReelState();
// }
//
// class _VideoReelState extends State<VideoReel> {
//   late VideoPlayerController _videoController;
//   ChewieController? _chewieController;
//   bool _isMuted = true;
//   bool _isVideoReady = false;
//   late String currentUserId;
//
//   String get videoUrl => widget.doc['fileUrl'];
//   String get thumbnailUrl => widget.doc['thumbnailUrl'] ?? '';
//   String get userName => widget.doc['userName'] ?? '';
//   String get caption => widget.doc['caption'] ?? '';
//   String get postId => widget.doc.id;
//
//   @override
//   void initState() {
//     super.initState();
//     currentUserId = FirebaseAuth.instance.currentUser!.uid;
//     _loadCachedVideo();
//   }
//
//   Future<void> _loadCachedVideo() async {
//     try {
//       final file = await DefaultCacheManager().getSingleFile(videoUrl);
//       _videoController = VideoPlayerController.file(file);
//       await _videoController.initialize();
//       _videoController.setVolume(0.0);
//       _videoController.setLooping(true);
//       _videoController.play();
//
//       _chewieController = ChewieController(
//         videoPlayerController: _videoController,
//         autoPlay: true,
//         looping: true,
//         showControls: false,
//       );
//
//       setState(() => _isVideoReady = true);
//     } catch (e) {
//       debugPrint("Video load error: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   void _toggleMute() {
//     setState(() {
//       _isMuted = !_isMuted;
//       _videoController.setVolume(_isMuted ? 0.0 : 1.0);
//     });
//   }
//
//   void _toggleLike(List likes) {
//     final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
//     if (likes.contains(currentUserId)) {
//       postRef.update({'likes': FieldValue.arrayRemove([currentUserId])});
//     } else {
//       postRef.update({'likes': FieldValue.arrayUnion([currentUserId])});
//     }
//   }
//
//   void _showLikedUsers(BuildContext context, List likedUserIds) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.black87,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         if (likedUserIds.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text('No likes yet.', style: TextStyle(color: Colors.white)),
//           );
//         }
//
//         return FutureBuilder<List<DocumentSnapshot>>(
//           future: Future.wait(
//             likedUserIds.map((uid) => FirebaseFirestore.instance.collection('users').doc(uid).get()),
//           ),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             final users = snapshot.data!;
//             return ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: users.length,
//               separatorBuilder: (_, __) => const Divider(color: Colors.white24),
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 final username = user['username'] ?? 'Unknown';
//                 final profileImage = user['profileImage'] ?? '';
//
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage:
//                     profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
//                     backgroundColor: Colors.grey,
//                   ),
//                   title: Text(username, style: const TextStyle(color: Colors.white)),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//       key: Key(postId),
//       onVisibilityChanged: (info) {
//         if (_isVideoReady) {
//           if (info.visibleFraction == 0) {
//             _videoController.pause();
//           } else {
//             _videoController.play();
//           }
//         }
//       },
//       child: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance.collection('posts').doc(postId).snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//
//           final docData = snapshot.data!.data() as Map<String, dynamic>;
//           final List likes = docData['likes'] != null ? List.from(docData['likes']) : [];
//
//           return GestureDetector(
//             onTap: () {
//               if (_isVideoReady) {
//                 setState(() {
//                   _videoController.value.isPlaying
//                       ? _videoController.pause()
//                       : _videoController.play();
//                 });
//               }
//             },
//             onDoubleTap: _toggleMute,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 // Show thumbnail while video loads
//                 if (!_isVideoReady && thumbnailUrl.isNotEmpty)
//                   Image.network(thumbnailUrl, fit: BoxFit.cover),
//
//                 // Show video when ready
//                 if (_isVideoReady && _chewieController != null)
//                   FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _videoController.value.size.width,
//                       height: _videoController.value.size.height,
//                       child: Chewie(controller: _chewieController!),
//                     ),
//                   ),
//
//                 // Text overlay
//                 Positioned(
//                   bottom: 20,
//                   left: 16,
//                   right: 80,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '@$userName',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           shadows: [Shadow(blurRadius: 6, color: Colors.black)],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         caption,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           shadows: [Shadow(blurRadius: 6, color: Colors.black)],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Action buttons
//                 Positioned(
//                   bottom: 40,
//                   right: 16,
//                   child: Column(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           likes.contains(currentUserId)
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           color: Colors.white,
//                         ),
//                         iconSize: 30,
//                         onPressed: () => _toggleLike(likes),
//                       ),
//                       GestureDetector(
//                         onTap: () => _showLikedUsers(context, likes),
//                         child: Text(
//                           '${likes.length}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Icon(Icons.comment, color: Colors.white, size: 30),
//                       const SizedBox(height: 16),
//                       const Icon(Icons.share, color: Colors.white, size: 30),
//                       const SizedBox(height: 16),
//                       GestureDetector(
//                         onTap: _toggleMute,
//                         child: Icon(
//                           _isMuted ? Icons.volume_off : Icons.volume_up,
//                           color: Colors.white.withOpacity(0.8),
//                           size: 36,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../controllers/reel_controller.dart';
import 'bottom_nav_bar.dart';

class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen>
    with WidgetsBindingObserver, RouteAware {
  final ReelController reelController = Get.find();
  final PageController pageController = PageController();
  int currentPageIndex = 0;

  // Only keep one active controller at a time
  VideoPlayerController? _activeController;
  int? _activeControllerIndex;
  bool _isInitializingController = false;

  bool isMuted = true;
  DateTime lastPageChangeTime = DateTime.now();
  bool _isDisposed = false;
  bool _isInBackground = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    try {
      WidgetsBinding.instance.addObserver(this);
      _safeInitialize();
    } catch (e) {
      print('Error in initState: $e');
      _handleCriticalError();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register with RouteObserver to detect navigation
    final RouteObserver<PageRoute> routeObserver = Get.find<RouteObserver<PageRoute>>();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  // Called when navigating away from this screen
  @override
  void didPushNext() {
    super.didPushNext();
    _pauseAndCleanupOnNavigation();
  }

  // Called when navigating back to this screen
  @override
  void didPopNext() {
    super.didPopNext();
    _resumeAfterNavigation();
  }

  void _pauseAndCleanupOnNavigation() {
    try {
      print('Navigation away detected - cleaning up video resources');
      _pauseCurrentVideo();
      _disposeActiveController();
      _isInBackground = true;
    } catch (e) {
      print('Error during navigation cleanup: $e');
    }
  }

  void _resumeAfterNavigation() {
    try {
      print('Navigation back detected - resuming video');
      _isInBackground = false;
      if (_isInitialized && !_isDisposed) {
        _initializeCurrentVideo();
      }
    } catch (e) {
      print('Error during navigation resume: $e');
    }
  }

  void _safeInitialize() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!_isDisposed && mounted) {
        _initializeCurrentVideo();
        _isInitialized = true;
      }
    } catch (e) {
      print('Error in safe initialize: $e');
      _handleCriticalError();
    }
  }

  void _handleCriticalError() {
    if (mounted && !_isDisposed) {
      setState(() {
        _disposeActiveController();
      });
    }
  }

  @override
  void dispose() {
    try {
      _isDisposed = true;
      WidgetsBinding.instance.removeObserver(this);
      final RouteObserver<PageRoute> routeObserver = Get.find<RouteObserver<PageRoute>>();
      routeObserver.unsubscribe(this);
      _disposeActiveController();
      pageController.dispose();
    } catch (e) {
      print('Error in dispose: $e');
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      switch (state) {
        case AppLifecycleState.paused:
        case AppLifecycleState.inactive:
        case AppLifecycleState.detached:
          _isInBackground = true;
          _pauseCurrentVideo();
          break;
        case AppLifecycleState.resumed:
          _isInBackground = false;
          _resumeCurrentVideo();
          break;
        case AppLifecycleState.hidden:
          break;
      }
    } catch (e) {
      print('Error in app lifecycle change: $e');
    }
  }

  void _pauseCurrentVideo() {
    try {
      if (_activeController != null &&
          _activeController!.value.isInitialized &&
          _activeController!.value.isPlaying) {
        _activeController!.pause();
      }
    } catch (e) {
      print('Error pausing current video: $e');
    }
  }

  void _resumeCurrentVideo() {
    try {
      if (_isDisposed || _isInBackground) return;

      if (_activeController != null &&
          _activeController!.value.isInitialized &&
          !_activeController!.value.isPlaying &&
          _activeControllerIndex == currentPageIndex) {
        _activeController!.play();
      }
    } catch (e) {
      print('Error resuming current video: $e');
    }
  }

  void _disposeActiveController() {
    try {
      if (_activeController != null) {
        print('Disposing active controller for index $_activeControllerIndex');
        final controller = _activeController!;
        _activeController = null;
        _activeControllerIndex = null;

        // Dispose in a separate microtask to avoid blocking UI
        Future.microtask(() {
          try {
            controller.dispose();
          } catch (e) {
            print('Error disposing active controller: $e');
          }
        });
      }
      _isInitializingController = false;
    } catch (e) {
      print('Error disposing active controller: $e');
    }
  }

  Future<void> _initializeCurrentVideo() async {
    await _initializeVideoAtIndex(currentPageIndex);
  }

  Future<void> _initializeVideoAtIndex(int index) async {
    // Safety checks
    if (_isDisposed ||
        !_isValidIndex(index) ||
        _isInitializingController ||
        (_activeControllerIndex == index && _activeController != null)) {
      return;
    }

    // Dispose previous controller if switching to different video
    if (_activeControllerIndex != index) {
      _disposeActiveController();
    }

    _isInitializingController = true;
    VideoPlayerController? controller;

    try {
      final videoData = reelController.videos[index];
      if (videoData == null) {
        throw Exception('Video data is null');
      }

      final videoUrl = videoData['fileUrl'];
      if (videoUrl == null || videoUrl.isEmpty) {
        throw Exception('Invalid video URL');
      }

      print('Initializing video controller for index $index');

      // Cache file with timeout
      final file = await DefaultCacheManager()
          .getSingleFile(videoUrl)
          .timeout(const Duration(seconds: 15));

      // Check if disposed during async operation
      if (_isDisposed) {
        return;
      }

      controller = VideoPlayerController.file(file);
      await controller.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );

      // Final disposal check
      if (_isDisposed) {
        controller.dispose();
        return;
      }

      // Configure controller
      try {
        controller.setLooping(true);
        controller.setVolume(isMuted ? 0.0 : 1.0);

        // Only play if this is the current video and not in background
        if (index == currentPageIndex && !_isInBackground) {
          await controller.play();
        }
      } catch (e) {
        print('Error configuring controller: $e');
      }

      // Update active controller
      if (mounted && !_isDisposed) {
        setState(() {
          _activeController = controller;
          _activeControllerIndex = index;
        });
        print('Successfully initialized controller for index $index');
      } else {
        controller.dispose();
      }
    } catch (e) {
      print('Error initializing video at index $index: $e');
      controller?.dispose();
    } finally {
      _isInitializingController = false;
    }
  }

  bool _isValidIndex(int index) {
    try {
      return index >= 0 && index < reelController.videos.length;
    } catch (e) {
      print('Error checking index validity: $e');
      return false;
    }
  }

  void onPageChanged(int index) {
    try {
      if (_isDisposed || !_isValidIndex(index)) return;

      DateTime now = DateTime.now();
      Duration diff = now.difference(lastPageChangeTime);
      lastPageChangeTime = now;

      print('Page changed to $index — time since last change: ${diff.inMilliseconds} ms');

      // Pause current video if playing
      _pauseCurrentVideo();

      // Update current page index
      currentPageIndex = index;

      // Initialize new video controller with debouncing
      if (diff.inMilliseconds > 200) {
        _initializeVideoAtIndex(index);
      } else {
        // For fast scrolling, delay initialization
        Future.delayed(const Duration(milliseconds: 300), () {
          if (currentPageIndex == index && !_isDisposed) {
            _initializeVideoAtIndex(index);
          }
        });
      }

      if (mounted && !_isDisposed) {
        setState(() {});
      }
    } catch (e) {
      print('Error in onPageChanged: $e');
    }
  }

  void toggleMute() {
    try {
      if (_isDisposed) return;

      setState(() {
        isMuted = !isMuted;
        // Apply mute state to active controller
        if (_activeController != null && _activeController!.value.isInitialized) {
          try {
            _activeController!.setVolume(isMuted ? 0.0 : 1.0);
          } catch (e) {
            print('Error setting volume: $e');
          }
        }
      });
    } catch (e) {
      print('Error in toggleMute: $e');
    }
  }

  void togglePlayPause() {
    try {
      if (_isDisposed) return;

      if (_activeController == null ||
          !_activeController!.value.isInitialized ||
          _activeControllerIndex != currentPageIndex) {
        return;
      }

      setState(() {
        try {
          if (_activeController!.value.isPlaying) {
            _activeController!.pause();
          } else {
            _activeController!.play();
          }
        } catch (e) {
          print('Error toggling play/pause: $e');
        }
      });
    } catch (e) {
      print('Error in togglePlayPause: $e');
    }
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                try {
                  if (mounted && !_isDisposed) {
                    _safeInitialize();
                  }
                } catch (e) {
                  print('Error in retry: $e');
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // Create separate widget for loading state
  Widget _buildLoadingIndicator() {
    return Obx(() {
      return reelController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink();
    });
  }

  // Create separate widget for video list
  Widget _buildVideoList() {
    return Obx(() {
      if (reelController.videos.isEmpty) {
        return _buildErrorWidget('No videos available');
      }

      return PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: reelController.videos.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          try {
            final video = reelController.videos[index];
            if (video == null) {
              return _buildErrorWidget('Video not found');
            }

            // Only provide controller if it's the active one for this index
            VideoPlayerController? controllerForThisIndex;
            if (_activeControllerIndex == index) {
              controllerForThisIndex = _activeController;
            }

            return VideoReel(
              key: ValueKey('${video.id}_$index'),
              doc: video,
              videoController: controllerForThisIndex,
              isMuted: isMuted,
              onToggleMute: toggleMute,
              onTogglePlayPause: togglePlayPause,
              isCurrentVideo: index == currentPageIndex,
              isLoading: _isInitializingController && index == currentPageIndex,
            );
          } catch (e) {
            print('Error building video reel at index $index: $e');
            return _buildErrorWidget('Error loading video');
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            if (_isInitialized) _buildVideoList(),

            // Loading overlay
            if (!_isInitialized)
              const Center(child: CircularProgressIndicator()),

            // Loading indicator for reelController
            _buildLoadingIndicator(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class VideoReel extends StatefulWidget {
  final DocumentSnapshot doc;
  final VideoPlayerController? videoController;
  final bool isMuted;
  final VoidCallback onToggleMute;
  final VoidCallback onTogglePlayPause;
  final bool isCurrentVideo;
  final bool isLoading;

  const VideoReel({
    super.key,
    required this.doc,
    required this.videoController,
    required this.isMuted,
    required this.onToggleMute,
    required this.onTogglePlayPause,
    required this.isCurrentVideo,
    required this.isLoading,
  });

  @override
  State<VideoReel> createState() => _VideoReelState();
}

class _VideoReelState extends State<VideoReel> {
  late String currentUserId;
  bool _isDisposed = false;

  String get videoUrl {
    try {
      return widget.doc['fileUrl'] ?? '';
    } catch (e) {
      print('Error getting video URL: $e');
      return '';
    }
  }

  String get thumbnailUrl {
    try {
      return widget.doc['thumbnailUrl'] ?? '';
    } catch (e) {
      print('Error getting thumbnail URL: $e');
      return '';
    }
  }

  String get userName {
    try {
      return widget.doc['userName'] ?? 'Unknown';
    } catch (e) {
      print('Error getting username: $e');
      return 'Unknown';
    }
  }

  String get caption {
    try {
      return widget.doc['caption'] ?? '';
    } catch (e) {
      print('Error getting caption: $e');
      return '';
    }
  }

  String get postId {
    try {
      return widget.doc.id;
    } catch (e) {
      print('Error getting post ID: $e');
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      final user = FirebaseAuth.instance.currentUser;
      currentUserId = user?.uid ?? '';
    } catch (e) {
      print('Error in VideoReel initState: $e');
      currentUserId = '';
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _toggleLike(List likes) {
    try {
      if (_isDisposed || currentUserId.isEmpty || postId.isEmpty) return;

      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      if (likes.contains(currentUserId)) {
        postRef.update({'likes': FieldValue.arrayRemove([currentUserId])});
      } else {
        postRef.update({'likes': FieldValue.arrayUnion([currentUserId])});
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  void _showLikedUsers(BuildContext context, List likedUserIds) {
    try {
      if (_isDisposed || !mounted) return;

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black87,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (bottomSheetContext) {
          if (likedUserIds.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No likes yet.', style: TextStyle(color: Colors.white)),
            );
          }

          return FutureBuilder<List<DocumentSnapshot>>(
            future: _fetchLikedUsers(likedUserIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Error loading users', style: TextStyle(color: Colors.white)),
                );
              }

              final users = snapshot.data ?? [];
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                itemBuilder: (context, index) {
                  return _buildUserListItem(users[index]);
                },
              );
            },
          );
        },
      );
    } catch (e) {
      print('Error showing liked users: $e');
    }
  }

  Future<List<DocumentSnapshot>> _fetchLikedUsers(List likedUserIds) async {
    try {
      final futures = likedUserIds.map((uid) =>
          FirebaseFirestore.instance.collection('users').doc(uid).get()
      );
      return await Future.wait(futures);
    } catch (e) {
      print('Error fetching liked users: $e');
      return [];
    }
  }

  Widget _buildUserListItem(DocumentSnapshot user) {
    try {
      final userData = user.data() as Map<String, dynamic>?;
      final username = userData?['username'] ?? 'Unknown';
      final profileImage = userData?['profileImage'] ?? '';

      return ListTile(
        leading: CircleAvatar(
          backgroundImage: profileImage.isNotEmpty
              ? NetworkImage(profileImage)
              : null,
          backgroundColor: Colors.grey,
          child: profileImage.isEmpty
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        title: Text(username, style: const TextStyle(color: Colors.white)),
      );
    } catch (e) {
      print('Error building user list item: $e');
      return ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: const Text('Unknown', style: TextStyle(color: Colors.white)),
      );
    }
  }

  Widget _buildVideoContent() {
    if (widget.isLoading || widget.videoController == null || !widget.videoController!.value.isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnailUrl.isNotEmpty)
            Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.video_library, color: Colors.white, size: 50),
                );
              },
            )
          else
            const Center(
              child: Icon(Icons.video_library, color: Colors.white, size: 50),
            ),
          if (widget.isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    return AspectRatio(
      aspectRatio: widget.videoController!.value.aspectRatio,
      child: VideoPlayer(widget.videoController!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(postId),
      onVisibilityChanged: (info) {
        try {
          if (_isDisposed || widget.videoController == null) return;

          if (info.visibleFraction == 0) {
            widget.videoController!.pause();
          } else if (widget.isCurrentVideo && info.visibleFraction > 0.5) {
            widget.videoController!.play();
          }
        } catch (e) {
          print('Error in visibility changed: $e');
        }
      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: postId.isNotEmpty
            ? FirebaseFirestore.instance.collection('posts').doc(postId).snapshots()
            : null,
        builder: (context, snapshot) {
          if (postId.isEmpty || _isDisposed) {
            return const Center(
              child: Text('Video not found', style: TextStyle(color: Colors.white)),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading video data', style: TextStyle(color: Colors.white)),
            );
          }

          if (!snapshot.hasData) {
            return _buildVideoContent();
          }

          final docData = snapshot.data!.data() as Map<String, dynamic>?;
          if (docData == null) {
            return const Center(
              child: Text('Video not found', style: TextStyle(color: Colors.white)),
            );
          }

          final List likes = docData['likes'] != null ? List.from(docData['likes']) : [];

          return GestureDetector(
            onTap: widget.onTogglePlayPause,
            onDoubleTap: widget.onToggleMute,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildVideoContent(),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@$userName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        caption,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 16,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          likes.contains(currentUserId)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: likes.contains(currentUserId)
                              ? Colors.red
                              : Colors.white,
                        ),
                        iconSize: 30,
                        onPressed: () => _toggleLike(likes),
                      ),
                      GestureDetector(
                        onTap: () => _showLikedUsers(context, List<String>.from(likes)),
                        child: Text(
                          '${likes.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Icon(Icons.comment, color: Colors.white, size: 30),
                      const SizedBox(height: 16),
                      const Icon(Icons.share, color: Colors.white, size: 30),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: widget.onToggleMute,
                        child: Icon(
                          widget.isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white.withOpacity(0.8),
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}