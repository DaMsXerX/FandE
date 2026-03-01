// new updates soon

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('userIds', arrayContains: currentUserId)
            // .orderBy('lastUpdated', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Add debug information
          print('Connection State: ${snapshot.connectionState}');
          print('Has Data: ${snapshot.hasData}');
          print('Has Error: ${snapshot.hasError}');
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Force rebuild
                      (context as Element).reassemble();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final chats = snapshot.data!.docs;
          print('Number of chats found: ${chats.length}');
          print('Current User ID: $currentUserId');

          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline,
                      color: Colors.white70, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'No chats yet',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'User ID: $currentUserId',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final chatData = chat.data() as Map<String, dynamic>;
              print('Chat $index data: $chatData');

              final List userIds = chatData['userIds'] ?? [];
              print('User IDs in chat: $userIds');

              if (userIds.length < 2) {
                return ListTile(
                  title: const Text('Invalid chat',
                      style: TextStyle(color: Colors.red)),
                  subtitle: Text('Chat ID: ${chat.id}',
                      style: const TextStyle(color: Colors.red)),
                );
              }

              final otherUserId = userIds.firstWhere(
                    (id) => id != currentUserId,
                orElse: () => null,
              );

              if (otherUserId == null) {
                return ListTile(
                  title: const Text('No other user found',
                      style: TextStyle(color: Colors.orange)),
                  subtitle: Text('User IDs: ${userIds.join(", ")}',
                      style: const TextStyle(color: Colors.orange)),
                );
              }

              print('Other user ID: $otherUserId');

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      title: const Text('Loading user...',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }

                  if (userSnapshot.hasError) {
                    print('User fetch error: ${userSnapshot.error}');
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red[800],
                        child: const Icon(Icons.error, color: Colors.white),
                      ),
                      title: const Text('Error loading user',
                          style: TextStyle(color: Colors.red)),
                      subtitle: Text('User ID: $otherUserId',
                          style: const TextStyle(color: Colors.red)),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange[800],
                        child: const Icon(Icons.person_off, color: Colors.white),
                      ),
                      title: const Text('User not found',
                          style: TextStyle(color: Colors.orange)),
                      subtitle: Text('User ID: $otherUserId',
                          style: const TextStyle(color: Colors.orange)),
                    );
                  }

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                  if (userData == null) {
                    return ListTile(
                      title: const Text('Invalid user data',
                          style: TextStyle(color: Colors.orange)),
                    );
                  }

                  final userName = userData['username'] ?? 'Unknown User';
                  final profileImage = userData['profileImage'] ?? '';
                  final lastMessage = chatData['lastMessage'] ?? 'No messages yet';
                  final lastUpdated = chatData['lastUpdated'] as Timestamp?;

                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        backgroundImage: profileImage.isNotEmpty
                            ? NetworkImage(profileImage)
                            : null,
                        child: profileImage.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      title: Text(
                        userName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lastMessage,
                            style: const TextStyle(color: Colors.white70),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (lastUpdated != null)
                            Text(
                              _formatTimestamp(lastUpdated),
                              style: const TextStyle(color: Colors.white38, fontSize: 12),
                            ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                      onTap: () {
                        print('Navigating to chat: ${chat.id}');
                        Get.to(() => ChatScreen(
                          chatId: chat.id,
                          otherUserId: otherUserId,
                        ));
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
