import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fande/screens/phone_auth_screen.dart';
import 'package:video_player/video_player.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_screen.dart';
import 'follow_list_screen.dart';
import 'video_player_screen.dart';
import 'image_preview_screen.dart';
import 'bottom_nav_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'edit') {
                Get.to(() => EditProfileScreen());
              } else if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => PhoneAuthScreen());
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Edit Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.userDetails;

        return RefreshIndicator(
          onRefresh: () async => controller.fetchUserDetails(),
          color: Colors.white,
          backgroundColor: Colors.black,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile image and username
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (user['profileImage'] != null && user['profileImage'] != "") {
                          Get.to(() => ImagePreviewScreen(
                            imageUrl: user['profileImage'],
                            // showAppBar: false, // for clean full screen
                          ));
                        }
                      },
                      child: Hero(
                        tag: 'profilePic',
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: (user['profileImage'] != null &&
                              user['profileImage'] != "")
                              ? NetworkImage(user['profileImage'])
                              : null,
                          child: (user['profileImage'] == null ||
                              user['profileImage'] == "")
                              ? const Icon(Icons.person, size: 40, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user['username'] ?? 'User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 30),
                // Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat(controller.userPosts.length.toString(), 'Posts'),
                          // Tappable Followers
                          Obx(() => GestureDetector(
                            onTap: () {
                              Get.to(() => FollowListScreen(
                                userId: controller.userDetails['uid'],
                                type: 'followers',
                              ));
                            },
                            child: _buildStat(controller.followersCount.toString(), 'Followers'),
                          )),
                          // Tappable Following
                          Obx(() => GestureDetector(
                            onTap: () {
                              Get.to(() => FollowListScreen(
                                userId: controller.userDetails['uid'],
                                type: 'following',
                              ));
                            },
                            child: _buildStat(controller.followingCount.toString(), 'Following'),
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Get.to(() => EditProfileScreen()),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

                Divider(color: Colors.grey.shade700),
                // Posts Grid
                controller.userPosts.isEmpty
                    ? const SizedBox(
                  height: 300,
                  child: Center(
                    child: Text("No posts found.", style: TextStyle(color: Colors.white60)),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.userPosts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final post = controller.userPosts[index];
                      final fileUrl = post['fileUrl'];
                      final fileType = post['fileType'];
                      final thumbnailUrl = post['thumbnailUrl'] ?? '';

                      return GestureDetector(
                        onTap: () {
                          if (fileType == 'image') {
                            Get.to(() => ImagePreviewScreen(imageUrl: post['fileUrl'],
                              docId: post.id,
                              fileUrl: post['fileUrl'],
                              thumbnailUrl: post['thumbnailUrl'],
                              uploaderId: post['userId'],));
                          } else {
                            Get.to(() => VideoPlayerScreen(
                              videoUrl: post['fileUrl'],
                              docId: post.id,
                              fileUrl: post['fileUrl'],
                              thumbnailUrl: post['thumbnailUrl'],
                              uploaderId: post['userId'],
                            ));

                          }
                        },
                        child: fileType == 'image'
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: fileUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.black12, child: const Center(child: CircularProgressIndicator())),
                            errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.broken_image, color: Colors.red)),
                          ),
                        )
                            : VideoTile(thumbnailUrl: thumbnailUrl),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class VideoTile extends StatelessWidget {
  final String thumbnailUrl;

  const VideoTile({Key? key, required this.thumbnailUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: thumbnailUrl,
            fit: BoxFit.cover, // Ensures image fills the grid tile
            placeholder: (context, url) => Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.broken_image, color: Colors.red)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
          const Positioned(
            bottom: 6,
            right: 6,
            child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 26),
          ),
        ],
      ),
    );
  }
}


