import 'package:video_player/video_player.dart';

class VideoControllerManager {
  static final Map<String, VideoPlayerController> _controllers = {};

  static Future<VideoPlayerController> getController(String url) async {
    if (_controllers.containsKey(url)) {
      return _controllers[url]!;
    }

    final controller = VideoPlayerController.network(url);
    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(0.0);
    _controllers[url] = controller;
    return controller;
  }

  static void disposeUnusedControllers(String keepUrl) {
    _controllers.removeWhere((url, controller) {
      if (url != keepUrl) {
        controller.dispose();
        return true;
      }
      return false;
    });
  }

  static void disposeAll() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
