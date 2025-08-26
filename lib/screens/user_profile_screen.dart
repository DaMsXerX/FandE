import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fande/screens/user_image_preview_screen.dart';
import 'package:fande/screens/user_video_player_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottom_nav_bar.dart';
import 'follow_list_screen.dart';
import 'chat_screen.dart'; // ⬅️ Make sure to import your ChatScreen

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isFollowing = false;
  int followersCount = 0;
  int followingCount = 0;
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> userPosts = [];
  bool isLoadingPosts = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserPosts();
    });
  }

  Future<void> loadUserProfile() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      final data = doc.data();
      if (data == null) return;

      final followingDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('followers')
          .doc(currentUser.uid)
          .get();

      final followersSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('followers')
          .get();

      final followingSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('following')
          .get();

      setState(() {
        userData = data;
        isFollowing = followingDoc.exists;
        followersCount = followersSnap.size;
        followingCount = followingSnap.size;
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> loadUserPosts() async {
    try {
      final postsSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: widget.userId)
          .get();

      setState(() {
        userPosts = postsSnap.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        isLoadingPosts = false;
      });
    } catch (e) {
      debugPrint('Error loading posts: $e');
      setState(() => isLoadingPosts = false);
    }
  }

  Future<void> toggleFollow() async {
    final docRef = FirebaseFirestore.instance.collection('users');

    if (isFollowing) {
      await docRef.doc(widget.userId).collection('followers').doc(currentUser.uid).delete();
      await docRef.doc(currentUser.uid).collection('following').doc(widget.userId).delete();
    } else {
      await docRef.doc(widget.userId).collection('followers').doc(currentUser.uid).set({
        'uid': currentUser.uid,
        'followedAt': FieldValue.serverTimestamp()
      });

      await docRef.doc(currentUser.uid).collection('following').doc(widget.userId).set({
        'uid': widget.userId,
        'followedAt': FieldValue.serverTimestamp()
      });
    }

    loadUserProfile();
  }

  Future<void> startChatWithUser(String otherUserId) async {
    final currentUserId = currentUser.uid;
    String chatId = getChatId(currentUserId, otherUserId);

    final chatDoc = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final docSnapshot = await chatDoc.get();

    if (!docSnapshot.exists) {
      await chatDoc.set({
        'userIds': [currentUserId, otherUserId],
        'lastMessage': '',
        'lastUpdated': Timestamp.now(),
      });
    }

    Get.to(() => ChatScreen(chatId: chatId, otherUserId: otherUserId));
  }

  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '${uid1}_$uid2' : '${uid2}_$uid1';
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          userData!['username'] ?? 'Profile',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.grey[900],
        onRefresh: () async {
          await loadUserProfile();
          await loadUserPosts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (userData!['profileImage'] != null && userData!['profileImage'] != "") {
                        Get.to(() => UserImagePreviewScreen(
                          imageUrl: userData!['profileImage'],
                          showAppBar: false,
                        ));
                      }
                    },
                    child: Hero(
                      tag: 'profilePic-${widget.userId}',
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: (userData!['profileImage'] != null && userData!['profileImage'] != "")
                            ? NetworkImage(userData!['profileImage'])
                            : null,
                        child: (userData!['profileImage'] == null || userData!['profileImage'] == "")
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn(userPosts.length, "Posts"),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => FollowListScreen(userId: widget.userId, type: 'followers'));
                          },
                          child: _buildStatColumn(followersCount, "Followers"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => FollowListScreen(userId: widget.userId, type: 'following'));
                          },
                          child: _buildStatColumn(followingCount, "Following"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  userData!['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  userData!['bio'] ?? '',
                  style: const TextStyle(fontSize: 15, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: toggleFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.grey[850] : Colors.blue,
                    side: isFollowing ? const BorderSide(color: Colors.white24) : BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await startChatWithUser(widget.userId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[850],
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.grey[800]),
              if (isLoadingPosts)
                const Center(child: CircularProgressIndicator(color: Colors.white))
              else if (userPosts.isEmpty)
                const Center(
                  child: Text("No posts found", style: TextStyle(color: Colors.white70)),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userPosts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    final post = userPosts[index];
                    final fileUrl = post['fileUrl'] ?? '';
                    final fileType = post['fileType'] ?? 'image';

                    return GestureDetector(
                      onTap: () {
                        if (fileType == 'image') {
                          Get.to(() => UserImagePreviewScreen(imageUrl: fileUrl));
                        } else if (fileType == 'video') {
                          Get.to(() => UserVideoPlayerScreen(videoUrl: fileUrl));
                        }
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (fileType == 'image')
                            Image.network(
                              fileUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, color: Colors.white54),
                            )
                          else
                            Stack(
                              fit: StackFit.expand,
                              children: [
                                if (post['thumbnailUrl'] != null)
                                  Image.network(
                                    post['thumbnailUrl'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(color: Colors.black12),
                                  )
                                else
                                  Container(color: Colors.black12),
                                const Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.play_circle_fill,
                                      size: 40, color: Colors.white),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildStatColumn(int count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
