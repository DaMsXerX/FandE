import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/upload_controller.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String docId;
  final String fileUrl;
  final String? thumbnailUrl;
  final String uploaderId;

  const VideoPlayerScreen({
    Key? key,
    required this.videoUrl,
    required this.docId,
    required this.fileUrl,
    this.thumbnailUrl,
    required this.uploaderId,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmAndDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Video'),
        content: const Text('Are you sure you want to permanently delete this video?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);

      try {
        final controller = Get.isRegistered<UploadController>()
            ? Get.find<UploadController>()
            : Get.put(UploadController());

        await controller.deletePost(
          docId: widget.docId,
          fileUrl: widget.fileUrl,
          thumbnailUrl: widget.thumbnailUrl,
        );

        Get.snackbar('Deleted', 'Video deleted successfully.',
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        Get.back(); // Close screen
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete video: $e',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Video",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (currentUser != null && currentUser.uid == widget.uploaderId)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _isDeleting ? null : _confirmAndDelete,
            ),
        ],
      ),
      body: _isDeleting
          ? const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      )
          : Center(
        child: _isInitialized
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: VideoPlayer(_controller),
            ),
          ),
        )
            : const CircularProgressIndicator(color: Colors.white),
      ),
      floatingActionButton: _isInitialized && !_isDeleting
          ? FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
