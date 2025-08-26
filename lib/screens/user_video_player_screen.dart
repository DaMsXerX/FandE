import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UserVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const UserVideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _UserVideoPlayerScreenState createState() => _UserVideoPlayerScreenState();
}

class _UserVideoPlayerScreenState extends State<UserVideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Video",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: _isInitialized
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: VideoPlayer(_controller),
            ),
          ),
        )
            : const CircularProgressIndicator(color: Colors.white),
      ),
      floatingActionButton: _isInitialized
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