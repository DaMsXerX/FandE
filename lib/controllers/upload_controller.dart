// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
//
// class UploadController extends GetxController {
//   Rx<File?> selectedFile = Rx<File?>(null);
//   RxString fileType = ''.obs; // 'image' or 'video'
//   final picker = ImagePicker();
//
//   Future<void> pickMedia(ImageSource source, {bool isVideo = false}) async {
//     XFile? pickedFile;
//
//     if (isVideo) {
//       pickedFile = await picker.pickVideo(source: source);
//       fileType.value = 'video';
//     } else {
//       pickedFile = await picker.pickImage(source: source, imageQuality: 75);
//       fileType.value = 'image';
//     }
//
//     if (pickedFile != null) {
//       selectedFile.value = File(pickedFile.path);
//     }
//   }
//
//   Future<void> uploadFile(String userId) async {
//     if (selectedFile.value == null) return;
//
//     try {
//       final file = selectedFile.value!;
//       final filename = basename(file.path);
//
//       // Use different folder based on fileType
//       final folder = fileType.value == 'video' ? 'videos' : 'images';
//
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child(folder)
//           .child(userId)
//           .child(filename);
//
//       await ref.putFile(file);
//       final downloadURL = await ref.getDownloadURL();
//
//       await FirebaseFirestore.instance.collection("posts").add({
//         'userId': userId,
//         'fileUrl': downloadURL,
//         'fileType': fileType.value,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       Get.snackbar("Uploaded", "File uploaded successfully");
//       selectedFile.value = null;
//       fileType.value = '';
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
// }


// implementing upload speed
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
//
// import 'package:video_compress/video_compress.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:uuid/uuid.dart';
//
// class UploadController extends GetxController {
//   Rx<File?> videoThumbnail = Rx<File?>(null);
//   Rx<File?> selectedFile = Rx<File?>(null);
//   RxString fileType = ''.obs; // 'image' or 'video'
//   RxDouble uploadProgress = 0.0.obs; // Re-added for progress tracking
//   RxBool isUploading = false.obs;
//   final picker = ImagePicker();
//
//   Future<void> pickMedia(ImageSource source, {bool isVideo = false}) async {
//     XFile? pickedFile;
//
//     if (isVideo) {
//       pickedFile = await picker.pickVideo(source: source);
//       fileType.value = 'video';
//     } else {
//       pickedFile = await picker.pickImage(source: source, imageQuality: 75);
//       fileType.value = 'image';
//     }
//
//     if (pickedFile != null) {
//       selectedFile.value = File(pickedFile.path);
//       final thumbnailInfo = await VideoCompress.getFileThumbnail(
//         pickedFile.path,
//         quality: 50, // 0-100
//         position: -1, // -1 means automatic mid-point
//       );
//       videoThumbnail.value = thumbnailInfo;
//     }
//   }
//
//   Future<XFile?> compressImage(File file) async {
//     final compressed = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path,
//       "${file.parent.path}/temp_${basenameWithoutExtension(file.path)}.jpeg", // Use basenameWithoutExtension and specific extension
//       quality: 70,
//     );
//     return compressed;
//   }
//
//   Future<MediaInfo?> compressVideo(File file) async {
//     return await VideoCompress.compressVideo(
//       file.path,
//       quality: VideoQuality.MediumQuality,
//       deleteOrigin: false,
//     );
//   }
//
//   Future<void> uploadFile({
//     required String userId,
//     required String userName,
//     String caption = '',
//   }) async {
//     if (selectedFile.value == null) return;
//
//     try {
//       final file = selectedFile.value!;
//       final uuid = const Uuid().v4(); // Unique file name
//       final folder = fileType.value == 'video' ? 'videos' : 'images';
//
//       File uploadFile = file;
//       String finalFileExtension;
//
//       if (fileType.value == 'image') {
//         final compressed = await compressImage(file);
//         if (compressed != null) {
//           uploadFile = compressed as File;
//           finalFileExtension = extension(compressed.path);
//         } else {
//           finalFileExtension = extension(file.path);
//         }
//       } else if (fileType.value == 'video') {
//         final compressedVideo = await compressVideo(file);
//         if (compressedVideo != null && compressedVideo.file != null) {
//           uploadFile = compressedVideo.file!;
//           finalFileExtension = extension(uploadFile.path);
//         } else {
//           finalFileExtension = extension(file.path);
//         }
//
//         // 🎯 Generate thumbnail for the video
//         final thumb = await VideoCompress.getFileThumbnail(
//           file.path,
//           quality: 50,
//           position: -1,
//         );
//         videoThumbnail.value = thumb;
//       } else {
//         finalFileExtension = extension(file.path);
//       }
//
//       final storagePath = '$folder/$userId/$uuid$finalFileExtension';
//       final ref = FirebaseStorage.instance.ref().child(storagePath);
//       final uploadTask = ref.putFile(uploadFile);
//
//       isUploading.value = true;
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
//       });
//
//       final snapshot = await uploadTask.whenComplete(() {});
//       final downloadURL = await snapshot.ref.getDownloadURL();
//
//       // 🔥 Upload thumbnail if it's a video
//       String? thumbnailUrl;
//       if (fileType.value == 'video' && videoThumbnail.value != null) {
//         final thumbRef = FirebaseStorage.instance
//             .ref()
//             .child('thumbnails/$userId/${uuid}.jpg');
//         await thumbRef.putFile(videoThumbnail.value!);
//         thumbnailUrl = await thumbRef.getDownloadURL();
//       }
//
//       await FirebaseFirestore.instance.collection("posts").add({
//         'userId': userId,
//         'userName': userName,
//         'caption': caption,
//         'fileUrl': downloadURL,
//         'fileType': fileType.value,
//         'thumbnailUrl': thumbnailUrl,
//         'timestamp': FieldValue.serverTimestamp(),
//         'likes': [],
//       });
//
//       Get.snackbar("Uploaded", "File uploaded successfully");
//       selectedFile.value = null;
//       fileType.value = '';
//       uploadProgress.value = 0.0;
//       videoThumbnail.value = null; // Reset thumbnail
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//       isUploading.value = false;
//       uploadProgress.value = 0.0;
//     }
//   }
//
// }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

class UploadController extends GetxController {
  Rx<File?> videoThumbnail = Rx<File?>(null);
  Rx<File?> selectedFile = Rx<File?>(null);
  RxString fileType = ''.obs;
  RxDouble uploadProgress = 0.0.obs;
  RxBool isUploading = false.obs;
  final picker = ImagePicker();

  Future<void> pickMedia(ImageSource source, {bool isVideo = false}) async {
    XFile? pickedFile;

    if (isVideo) {
      pickedFile = await picker.pickVideo(source: source);
      fileType.value = 'video';
    } else {
      pickedFile = await picker.pickImage(source: source, imageQuality: 75);
      fileType.value = 'image';
    }

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      selectedFile.value = file;

      // Generate thumbnail only if it's a video
      if (fileType.value == 'video') {
        final thumbnail = await VideoCompress.getFileThumbnail(
          file.path,
          quality: 50,
          position: -1,
        );
        videoThumbnail.value = thumbnail;
      }
    }
  }

  Future<XFile?> compressImage(File file) async {
    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      "${file.parent.path}/temp_${basenameWithoutExtension(file.path)}.jpeg",
      quality: 70,
    );
    return compressed;
  }

  Future<MediaInfo?> compressVideo(File file) async {
    return await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
  }

  Future<void> deletePost({
    required String docId,
    required String fileUrl,
    String? thumbnailUrl,
  }) async {
    try {
      // Delete media file
      final fileRef = FirebaseStorage.instance.refFromURL(fileUrl);
      await fileRef.delete();

      // Delete thumbnail if exists
      if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
        final thumbRef = FirebaseStorage.instance.refFromURL(thumbnailUrl);
        await thumbRef.delete();
      }

      // Delete document from Firestore
      await FirebaseFirestore.instance.collection('posts').doc(docId).delete();

      Get.snackbar("Deleted", "Post deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete post: $e");
    }
  }


  Future<void> uploadFile({
    required String userId,
    required String userName,
    String caption = '',
  }) async {
    final file = selectedFile.value;
    if (file == null || fileType.value.isEmpty) {
      Get.snackbar("Error", "No media selected");
      return;
    }

    try {
      isUploading.value = true;
      final uuid = const Uuid().v4();
      final folder = fileType.value == 'video' ? 'videos' : 'images';
      File uploadFile = file;
      String extensionToUse;

      if (fileType.value == 'image') {
        final compressed = await compressImage(file);
        if (compressed != null) {
          uploadFile = File(compressed.path);
        }
        extensionToUse = extension(uploadFile.path);
      } else {
        final compressed = await compressVideo(file);
        if (compressed != null && compressed.file != null) {
          uploadFile = compressed.file!;
        }
        extensionToUse = extension(uploadFile.path);
      }

      final storagePath = '$folder/$userId/$uuid$extensionToUse';
      final ref = FirebaseStorage.instance.ref().child(storagePath);
      final uploadTask = ref.putFile(uploadFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value = snapshot.bytesTransferred / snapshot.totalBytes;
      });

      final snapshot = await uploadTask;
      final fileUrl = await snapshot.ref.getDownloadURL();

      String? thumbnailUrl;
      if (fileType.value == 'video' && videoThumbnail.value != null) {
        final thumbRef = FirebaseStorage.instance
            .ref()
            .child('thumbnails/$userId/${uuid}.jpg');
        await thumbRef.putFile(videoThumbnail.value!);
        thumbnailUrl = await thumbRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection("posts").add({
        'userId': userId,
        'userName': userName,
        'caption': caption.trim(),
        'fileUrl': fileUrl,
        'fileType': fileType.value,
        'thumbnailUrl': thumbnailUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': [],
      });

      // Reset state
      isUploading.value = false;
      uploadProgress.value = 0.0;
      selectedFile.value = null;
      fileType.value = '';
      videoThumbnail.value = null;
      VideoCompress.deleteAllCache();

      Get.snackbar("Success", "File uploaded successfully");
    } catch (e) {
      isUploading.value = false;
      uploadProgress.value = 0.0;
      Get.snackbar("Upload Failed", e.toString());
    }
  }
}

