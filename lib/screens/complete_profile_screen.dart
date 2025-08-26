import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'profile_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final User user;

  CompleteProfileScreen({required this.user});

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File? _pickedImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  Future<String?> _uploadImage(File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profileImages/${widget.user.uid}.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final bio = bioController.text.trim();

    if (name.isEmpty || username.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields");
      return;
    }

    setState(() => isLoading = true);

    String? imageUrl;
    if (_pickedImage != null) {
      imageUrl = await _uploadImage(_pickedImage!);
    }

    await FirebaseFirestore.instance.collection("users").doc(widget.user.uid).set({
      "uid": widget.user.uid,
      "name": name,
      "username": username,
      // "searchName": username.toLowerCase(),
      "bio": bio,
      "phone": widget.user.phoneNumber,
      "profileImage": imageUrl ?? "",
      "createdAt": Timestamp.now(),
      "followerCount": 0,
      "followingCount": 0,
    });

    setState(() => isLoading = false);
    Get.offAll(() => ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage!) : null,
                child: _pickedImage == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Bio",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: saveProfile,
              icon: const Icon(Icons.check),
              label: const Text("Save & Continue"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
