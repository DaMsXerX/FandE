import 'package:fande/screens/profile_screen.dart';
import 'package:fande/screens/upload_screen.dart';
import 'package:fande/screens/video_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'discover_screen.dart';
import 'notification_screen.dart';

class BottomNavBar extends StatelessWidget {
  final Color activeColor = Colors.orange;
  final Color inactiveColor = Colors.grey.shade600;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.video_collection_outlined,
            label: "Reels",
            onTap: () => Get.to(() => VideoFeedScreen()),
          ),
          _buildNavItem(
            icon: Icons.search,
            label: "Discover",
            onTap: () => Get.to(() => HomeScreen()),
          ),
          _buildNavItem(
            icon: Icons.notifications_none,
            label: "Inbox",
            onTap: () => Get.to(() => NotificationScreen()),
          ),
          _buildNavItem(
            icon: Icons.add_circle_outline,
            label: "Upload",
            onTap: () => Get.to(() => UploadScreen()),
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            label: "Profile",
            onTap: () => Get.to(() => ProfileScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: inactiveColor),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: inactiveColor, fontSize: 12)),
        ],
      ),
    );
  }
}
