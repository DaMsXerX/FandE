// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import '../controllers/upload_controller.dart';
// import '../controllers/auth_controller.dart';
//
// class UploadScreen extends StatefulWidget {
//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }
//
// class _UploadScreenState extends State<UploadScreen> {
//   final UploadController uploadController = Get.put(UploadController());
//   final AuthController authController = Get.find();
//   VideoPlayerController? _videoController;
//
//   void _initializeVideo(File file) {
//     _videoController?.dispose();
//     _videoController = VideoPlayerController.file(file)
//       ..initialize().then((_) {
//         setState(() {});
//         _videoController?.play();
//       });
//   }
//
//   void _showMediaPickerSheet() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_camera),
//               title: Text("Take Photo"),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.camera, isVideo: false);
//                 if (uploadController.fileType.value == 'video') {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text("Pick Image from Gallery"),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.gallery, isVideo: false);
//                 if (uploadController.fileType.value == 'video') {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.videocam),
//               title: Text("Record Video"),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.camera, isVideo: true);
//                 if (uploadController.fileType.value == 'video') {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.video_library),
//               title: Text("Pick Video from Gallery"),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.gallery, isVideo: true);
//                 if (uploadController.fileType.value == 'video') {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("New Post", style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         actions: [
//           TextButton(
//             onPressed: () {
//               final user = authController.auth.currentUser;
//               if (user != null) {
//                 uploadController.uploadFile(user.uid);
//               }
//             },
//             child: Text("Post", style: TextStyle(color: Colors.blue, fontSize: 16)),
//           )
//         ],
//       ),
//       body: Obx(() {
//         final file = uploadController.selectedFile.value;
//         final type = uploadController.fileType.value;
//
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               if (file != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     height: 350,
//                     width: double.infinity,
//                     color: Colors.black12,
//                     child: type == 'video'
//                         ? (_videoController != null && _videoController!.value.isInitialized
//                         ? AspectRatio(
//                       aspectRatio: _videoController!.value.aspectRatio,
//                       child: VideoPlayer(_videoController!),
//                     )
//                         : Center(child: CircularProgressIndicator()))
//                         : Image.file(file, fit: BoxFit.cover),
//                   ),
//                 )
//               else
//                 Container(
//                   height: 350,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey.shade400),
//                   ),
//                   child: Center(
//                     child: Text("No media selected", style: TextStyle(color: Colors.grey)),
//                   ),
//                 ),
//               SizedBox(height: 20),
//               OutlinedButton.icon(
//                 icon: Icon(Icons.add_photo_alternate, color: Colors.blue),
//                 label: Text("Choose Media", style: TextStyle(color: Colors.blue)),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Colors.blue),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onPressed: _showMediaPickerSheet,
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import '../controllers/upload_controller.dart';
// import '../controllers/auth_controller.dart';
// import 'bottom_nav_bar.dart';
//
// class UploadScreen extends StatefulWidget {
//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }
//
// class _UploadScreenState extends State<UploadScreen> {
//   final UploadController uploadController = Get.put(UploadController());
//   final AuthController authController = Get.find<AuthController>();
//   VideoPlayerController? _videoController;
//   final TextEditingController _captionController = TextEditingController();
//
//   void _initializeVideo(File file) {
//     _videoController?.dispose();
//     _videoController = VideoPlayerController.file(file)
//       ..initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//         _videoController?.play();
//         _videoController?.setLooping(true);
//       });
//   }
//
//   void _showMediaPickerSheet() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[900],
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_camera, color: Colors.white),
//               title: Text("Take Photo", style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.camera, isVideo: false);
//                 if (uploadController.fileType.value == 'video' && uploadController.selectedFile.value != null) {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library, color: Colors.white),
//               title: Text("Pick Image from Gallery", style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.gallery, isVideo: false);
//                 if (uploadController.fileType.value == 'video' && uploadController.selectedFile.value != null) {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.videocam, color: Colors.white),
//               title: Text("Record Video", style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.camera, isVideo: true);
//                 if (uploadController.fileType.value == 'video' && uploadController.selectedFile.value != null) {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.video_library, color: Colors.white),
//               title: Text("Pick Video from Gallery", style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.gallery, isVideo: true);
//                 if (uploadController.fileType.value == 'video' && uploadController.selectedFile.value != null) {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: false,
//     );
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _captionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text("New Post", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//         centerTitle: true,
//         actions: [
//           Obx(() {
//             final file = uploadController.selectedFile.value;
//             return TextButton(
//               onPressed: file == null
//                   ? null
//                   : () async {
//                 final user = authController.auth.currentUser;
//                 if (user != null) {
//                   final userName = await authController.getUserName(user.uid);
//                   uploadController.uploadFile(
//                     userId: user.uid,
//                     userName: userName,
//                     caption: _captionController.text.trim(),
//                   );
//                 } else {
//                   Get.snackbar("Error", "User not logged in");
//                 }
//               },
//               child: Text(
//                 "Post",
//                 style: TextStyle(
//                   color: file == null ? Colors.grey : Colors.blue,
//                   fontSize: 16,
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//       body: Obx(() {
//         final file = uploadController.selectedFile.value;
//         final type = uploadController.fileType.value;
//
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               if (file != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     height: 350,
//                     width: double.infinity,
//                     color: Colors.black12,
//                     child: type == 'video'
//                         ? (_videoController != null && _videoController!.value.isInitialized
//                         ? AspectRatio(
//                       aspectRatio: _videoController!.value.aspectRatio,
//                       child: VideoPlayer(_videoController!),
//                     )
//                         : Center(child: CircularProgressIndicator()))
//                         : Image.file(file, fit: BoxFit.cover),
//                   ),
//                 )
//               else
//                 Container(
//                   height: 350,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[850],
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey.shade700),
//                   ),
//                   child: Center(
//                     child: Text("No media selected", style: TextStyle(color: Colors.grey)),
//                   ),
//                 ),
//               SizedBox(height: 20),
//
//               // Caption input field
//               TextField(
//                 controller: _captionController,
//                 maxLines: 3,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: "Write a caption...",
//                   hintStyle: TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//
//               SizedBox(height: 20),
//
//               OutlinedButton.icon(
//                 icon: Icon(Icons.add_photo_alternate, color: Colors.blue),
//                 label: Text("Choose Media", style: TextStyle(color: Colors.blue)),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Colors.blue),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onPressed: _showMediaPickerSheet,
//               ),
//             ],
//           ),
//         );
//       }),
//       bottomNavigationBar:  BottomNavBar(),
//     );
//   }
// }




//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import '../controllers/upload_controller.dart';
// import '../controllers/auth_controller.dart';
// import 'bottom_nav_bar.dart';
//
// class UploadScreen extends StatefulWidget {
//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }
//
// class _UploadScreenState extends State<UploadScreen> {
//   final UploadController uploadController = Get.put(UploadController());
//   final AuthController authController = Get.find<AuthController>();
//   VideoPlayerController? _videoController;
//   final TextEditingController _captionController = TextEditingController();
//
//   void _initializeVideo(File file) {
//     _videoController?.dispose();
//     _videoController = VideoPlayerController.file(file)
//       ..initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//         _videoController?.play();
//         _videoController?.setLooping(true);
//       });
//   }
//
//   void _showMediaPickerSheet() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[900],
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_camera, color: Colors.white),
//               title: Text("Take Photo", style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.camera, isVideo: false);
//                 if (uploadController.fileType.value == 'video' && uploadController.selectedFile.value != null) {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library, color: Colors.white),
//               title: Text("Pick Image from Gallery", style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.gallery, isVideo: false);
//                 if (uploadController.fileType.value == 'video' && uploadController.selectedFile.value != null) {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.videocam, color: Colors.white),
//               title: Text("Record Video", style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.camera, isVideo: true);
//                 if (uploadController.fileType.value == 'video' && uploadController.selectedFile.value != null) {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.video_library, color: Colors.white),
//               title: Text("Pick Video from Gallery", style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 await uploadController.pickMedia(ImageSource.gallery, isVideo: true);
//                 if (uploadController.fileType.value == 'video' && uploadController.selectedFile.value != null) {
//                   _initializeVideo(uploadController.selectedFile.value!);
//                 }
//                 Get.back();
//               },
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: false,
//     );
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _captionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text("New Post", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//         centerTitle: true,
//         actions: [
//           Obx(() {
//             final file = uploadController.selectedFile.value;
//             return TextButton(
//               onPressed: file == null
//                   ? null
//                   : () async {
//                 final user = authController.auth.currentUser;
//                 if (user != null) {
//                   final userName = await authController.getUserName(user.uid);
//                   uploadController.uploadFile(
//                     userId: user.uid,
//                     userName: userName,
//                     caption: _captionController.text.trim(),
//                   );
//                 } else {
//                   Get.snackbar("Error", "User not logged in");
//                 }
//               },
//               child: Text(
//                 "Post",
//                 style: TextStyle(
//                   color: file == null ? Colors.grey : Colors.blue,
//                   fontSize: 16,
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//       body: Obx(() {
//         final file = uploadController.selectedFile.value;
//         final type = uploadController.fileType.value;
//
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               if (file != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     height: 350,
//                     width: double.infinity,
//                     color: Colors.black12,
//                     child: type == 'video'
//                         ? (_videoController != null && _videoController!.value.isInitialized
//                         ? AspectRatio(
//                       aspectRatio: _videoController!.value.aspectRatio,
//                       child: VideoPlayer(_videoController!),
//                     )
//                         : Center(child: CircularProgressIndicator()))
//                         : Image.file(file, fit: BoxFit.cover),
//                   ),
//                 )
//               else
//                 Container(
//                   height: 350,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[850],
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey.shade700),
//                   ),
//                   child: Center(
//                     child: Text("No media selected", style: TextStyle(color: Colors.grey)),
//                   ),
//                 ),
//               SizedBox(height: 20),
//
//               // Caption input field
//               TextField(
//                 controller: _captionController,
//                 maxLines: 3,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: "Write a caption...",
//                   hintStyle: TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//
//               SizedBox(height: 20),
//
//               if (uploadController.isUploading.value)
//                 Column(
//                   children: [
//                     LinearProgressIndicator(
//                       value: uploadController.uploadProgress.value,
//                       backgroundColor: Colors.grey[800],
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "${(uploadController.uploadProgress.value * 100).toStringAsFixed(0)}% uploaded",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//
//
//
//               OutlinedButton.icon(
//                 icon: Icon(Icons.add_photo_alternate, color: Colors.blue),
//                 label: Text("Choose Media", style: TextStyle(color: Colors.blue)),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Colors.blue),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onPressed: _showMediaPickerSheet,
//               ),
//             ],
//           ),
//         );
//       }),
//       bottomNavigationBar:  BottomNavBar(),
//     );
//   }
// }








import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../controllers/upload_controller.dart';
import '../controllers/auth_controller.dart';
import 'bottom_nav_bar.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final UploadController uploadController = Get.put(UploadController());
  final AuthController authController = Get.find<AuthController>();

  // Instance video controller for better lifecycle management
  VideoPlayerController? _videoController;
  bool _isVideoInitializing = false;
  bool _videoInitialized = false;

  final TextEditingController _captionController = TextEditingController();

  // Constants for better maintainability
  static const double _mediaPreviewHeight = 400.0;
  static const double _borderRadius = 20.0;
  static const int _maxCaptionLength = 500;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen to upload controller changes
    ever(uploadController.selectedFile, (File? file) {
      _handleFileChange(file);
    });

    // Check if we already have a selected file
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndInitializeVideo();
    });
  }

  void _checkAndInitializeVideo() {
    final file = uploadController.selectedFile.value;
    if (file != null && uploadController.fileType.value == 'video') {
      _initializeVideoSafely(file);
    }
  }

  void _handleFileChange(File? file) {
    if (file == null) {
      _cleanupVideoController();
    } else if (uploadController.fileType.value == 'video') {
      _initializeVideoSafely(file);
    } else {
      // It's an image, cleanup any existing video
      _cleanupVideoController();
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _cleanupVideoController();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_videoController == null || !_videoInitialized) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _videoController?.pause();
        break;
      case AppLifecycleState.resumed:
        if (_videoController?.value.isInitialized == true && mounted) {
          _videoController?.play();
        }
        break;
      default:
        break;
    }
  }

  void _cleanupVideoController() {
    _videoController?.dispose();
    _videoController = null;
    _videoInitialized = false;
    _isVideoInitializing = false;
  }

  Future<void> _initializeVideoSafely(File file) async {
    // Prevent multiple initializations
    if (_isVideoInitializing) return;

    setState(() {
      _isVideoInitializing = true;
    });

    try {
      // Cleanup previous video controller
      _cleanupVideoController();

      _videoController = VideoPlayerController.file(file);

      await _videoController!.initialize();

      if (!mounted) return;

      setState(() {
        _videoInitialized = true;
        _isVideoInitializing = false;
      });

      // Auto-play and loop
      await _videoController!.play();
      await _videoController!.setLooping(true);

    } catch (e) {
      if (mounted) {
        setState(() {
          _isVideoInitializing = false;
          _videoInitialized = false;
        });
      }
      debugPrint('Error initializing video: $e');
      _showErrorSnackbar('Failed to load video. Please try again.');
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      duration: Duration(seconds: 3),
    );
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      duration: Duration(seconds: 3),
    );
  }

  Future<void> _handleMediaSelection(ImageSource source, bool isVideo) async {
    try {
      // Show loading indicator
      Get.dialog(
        Center(child: CircularProgressIndicator(color: Colors.blue)),
        barrierDismissible: false,
      );

      await uploadController.pickMedia(source, isVideo: isVideo);

      Get.back(); // Close loading dialog
      Get.back(); // Close bottom sheet

      // Force a rebuild to ensure UI updates
      if (mounted) {
        setState(() {});
      }

    } catch (e) {
      Get.back(); // Close loading dialog if open
      debugPrint('Error selecting media: $e');
      _showErrorSnackbar('Failed to select media. Please try again.');
    }
  }

  void _showMediaPickerSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[850]!, Colors.grey[900]!],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Text(
                "Select Media",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24),

              // Options
              ..._buildMediaPickerOptions(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  List<Widget> _buildMediaPickerOptions() {
    final options = [
      _MediaPickerOption(
        icon: Icons.photo_camera,
        title: "Take Photo",
        subtitle: "Capture with camera",
        onTap: () => _handleMediaSelection(ImageSource.camera, false),
      ),
      _MediaPickerOption(
        icon: Icons.photo_library,
        title: "Photo Gallery",
        subtitle: "Choose from gallery",
        onTap: () => _handleMediaSelection(ImageSource.gallery, false),
      ),
      _MediaPickerOption(
        icon: Icons.videocam,
        title: "Record Video",
        subtitle: "Capture with camera",
        onTap: () => _handleMediaSelection(ImageSource.camera, true),
      ),
      _MediaPickerOption(
        icon: Icons.video_library,
        title: "Video Gallery",
        subtitle: "Choose from gallery",
        onTap: () => _handleMediaSelection(ImageSource.gallery, true),
      ),
    ];

    return options.map((option) => Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(option.icon, color: Colors.blue, size: 24),
        ),
        title: Text(
          option.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          option.subtitle,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 16),
        onTap: option.onTap,
      ),
    )).toList();
  }

  Future<void> _handleUpload() async {
    final user = authController.auth.currentUser;
    if (user == null) {
      _showErrorSnackbar("Please log in to continue");
      return;
    }

    // Caption is now optional - remove the validation
    // if (_captionController.text.trim().isEmpty) {
    //   _showErrorSnackbar("Please add a caption");
    //   return;
    // }

    if (uploadController.selectedFile.value == null) {
      _showErrorSnackbar("Please select media to upload");
      return;
    }

    try {
      final userName = await authController.getUserName(user.uid);
      await uploadController.uploadFile(
        userId: user.uid,
        userName: userName,
        caption: _captionController.text.trim(), // Use empty string if no caption
      );

      // Clear form after successful upload
      _captionController.clear();
      _cleanupVideoController();

      _showSuccessSnackbar("Post uploaded successfully!");
    } catch (e) {
      debugPrint('Upload error: $e');
      _showErrorSnackbar("Failed to upload post. Please try again.");
    }
  }

  Widget _buildMediaPreview() {
    return Obx(() {
      final file = uploadController.selectedFile.value;
      final type = uploadController.fileType.value;

      return Container(
        height: _mediaPreviewHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: file == null
              ? _buildPlaceholderContainer()
              : type == 'video'
              ? _buildVideoPreview()
              : _buildImagePreview(file),
        ),
      );
    });
  }

  Widget _buildPlaceholderContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[800]!, Colors.grey[900]!],
        ),
        border: Border.all(color: Colors.grey.shade700, width: 2),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "No media selected",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Tap 'Choose Media' to get started",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    // Show loading while initializing
    if (_isVideoInitializing || _videoController == null || !_videoInitialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 3,
              ),
              SizedBox(height: 20),
              Text(
                "Loading video...",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Video is ready
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),

          // Play/Pause overlay
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
                });
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Video duration indicator
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatDuration(_videoController!.value.duration),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(File file) {
    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[800],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(
                  "Failed to load image",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() {}),
                  child: Text(
                    "Tap to retry",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCaptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: TextField(
        controller: _captionController,
        maxLines: 4,
        maxLength: _maxCaptionLength,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: "Write a caption for your post... (optional)",
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          counterStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }

  Widget _buildUploadProgress() {
    return Obx(() {
      if (!uploadController.isUploading.value) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircularProgressIndicator(
                  value: uploadController.uploadProgress.value,
                  backgroundColor: Colors.grey[700],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 3,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Uploading your post...",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${(uploadController.uploadProgress.value * 100).toStringAsFixed(0)}% complete",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: uploadController.uploadProgress.value,
              backgroundColor: Colors.grey[700],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 6,
            ),
          ],
        ),
      );
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ),
          ),
        ),
        title: Text(
          "Create Post",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            final file = uploadController.selectedFile.value;
            final isUploading = uploadController.isUploading.value;

            return Container(
              margin: EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed: (file == null || isUploading) ? null : _handleUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: file == null ? Colors.grey[700] : Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: isUploading
                    ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  "Post",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMediaPreview(),
              SizedBox(height: 32),
              _buildCaptionField(),
              SizedBox(height: 24),
              _buildUploadProgress(),

              if (!uploadController.isUploading.value) ...[
                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade400],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add_photo_alternate, color: Colors.white),
                    label: Text(
                      "Choose Media",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: _showMediaPickerSheet,
                  ),
                ),
              ],
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

// Helper class for media picker options
class _MediaPickerOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MediaPickerOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}