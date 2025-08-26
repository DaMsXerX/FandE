import 'package:fande/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/follow_list_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'bottom_nav_bar.dart';

class FollowListScreen extends StatelessWidget {
  final String userId;
  final String type;

  FollowListScreen({required this.userId, required this.type});

  @override
  Widget build(BuildContext context) {
    final tag = '$userId-$type';
    final FollowListController controller = Get.put(
      FollowListController(userId: userId, type: type),
      tag: tag, // ensure unique instance for each screen
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(type.capitalizeFirst!),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Obx(() => controller.usersList.isEmpty
          ? const Center(child: Text('No users found', style: TextStyle(color: Colors.white60)))
          : ListView.builder(
          itemCount: controller.usersList.length,
          itemBuilder: (context, index) {
            final user = controller.usersList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user['profileImage'] != null && user['profileImage'] != ''
                    ? CachedNetworkImageProvider(user['profileImage'])
                    : null,
                backgroundColor: Colors.grey,
                child: user['profileImage'] == null || user['profileImage'] == ''
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              title: Text(user['username'] ?? 'User', style: const TextStyle(color: Colors.white)),
              subtitle: Text(user['email'] ?? '', style: const TextStyle(color: Colors.white54)),
              onTap: () {
                // Navigate to user's public profile
                Get.to(() => UserProfileScreen(userId: user['uid']));
              },
            );
          })),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
