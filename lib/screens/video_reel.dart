// reel_item.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelItem extends StatelessWidget {
  final VideoPlayerController controller;
  final String userName;
  final String caption;

  const ReelItem({
    super.key,
    required this.controller,
    required this.userName,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          )
              : const CircularProgressIndicator(),
        ),
        Positioned(
          bottom: 40,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 4),
              Text(caption, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
