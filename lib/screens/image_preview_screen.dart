import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/upload_controller.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imageUrl;
  final bool showAppBar;
  final String? docId;
  final String? fileUrl;
  final String? thumbnailUrl;
  final String? uploaderId;

  const ImagePreviewScreen({
    required this.imageUrl,
    this.showAppBar = true,
    this.docId,
    this.fileUrl,
    this.thumbnailUrl,
    this.uploaderId,
    Key? key,
  }) : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _isDeleting = false;

  Future<void> _confirmAndDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to permanently delete this image?'),
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
          docId: widget.docId!,
          fileUrl: widget.fileUrl!,
          thumbnailUrl: widget.thumbnailUrl,
        );

        Get.snackbar('Deleted', 'Image deleted successfully.',
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        Get.back(); // Close screen
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete image: $e',
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
    final canDelete = widget.docId != null &&
        widget.fileUrl != null &&
        widget.uploaderId != null &&
        currentUser != null &&
        currentUser.uid == widget.uploaderId;

    return Scaffold(
      backgroundColor: Colors.black, // dark background
      appBar: widget.showAppBar
          ? AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Image View",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // back button color
        elevation: 1,
        actions: [
          if (canDelete)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _isDeleting ? null : _confirmAndDelete,
            ),
        ],
      )
          : null,
      body: _isDeleting
          ? const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white24,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.network(
                  widget.imageUrl,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red, size: 60),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}