import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

import '../controllers/profile_controller.dart';
import 'bottom_nav_bar.dart'; // Adjust the path as needed

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _phoneController =
  TextEditingController(text: '9603456878');
  final TextEditingController _emailController =
  TextEditingController(text: 'test@abc.com');
  final TextEditingController _passwordController =
  TextEditingController(text: '******');
  final TextEditingController _instagramUrlController =
  TextEditingController();

  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _instagramUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Obx(() {
                final imageUrl =
                    _profileController.userDetails['profileImage'] ?? '';
                return Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 10),
            Obx(() {
              final username =
                  _profileController.userDetails['username'] ?? 'Unknown';
              return Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
            const SizedBox(height: 40),
            _buildProfileInputField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.edit,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildProfileInputField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.edit,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildProfileInputField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.edit,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _buildProfileInputField(
              controller: _instagramUrlController,
              label: 'Instagram Url',
              icon: Icons.edit,
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),

      /// ✅ Your already created navigation bar:
      bottomNavigationBar: BottomNavBar(), // Replace this with your widget name
    );
  }

  Widget _buildProfileInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: Icon(icon, color: Colors.white),
            contentPadding: const EdgeInsets.only(bottom: 8),
          ),
          cursorColor: Colors.white,
        ),
      ],
    );
  }
}
