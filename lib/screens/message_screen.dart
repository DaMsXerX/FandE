import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';
import 'notification_screen.dart';

// --- Data Model for Messages ---
class MessageItem {
  final String userName;
  final String lastMessage;
  final String timeAgo;
  final String userAvatarAsset; // Local asset image
  final bool hasUnread; // To show the orange dot

  const MessageItem({
    required this.userName,
    required this.lastMessage,
    required this.timeAgo,
    required this.userAvatarAsset,
    this.hasUnread = false,
  });
}

// --- Message Screen Widget ---
class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  final List<MessageItem> _messages = const [
    MessageItem(
      userName: 'Ellison Perry',
      lastMessage: 'Hey, Kaise ho?',
      timeAgo: '1d ago',
      userAvatarAsset: 'images/avatar6.jpg',
      hasUnread: true,
    ),
    MessageItem(
      userName: 'Mark Perry',
      lastMessage: 'Kal oofice aaoge?',
      timeAgo: '2d ago',
      userAvatarAsset: 'images/avatar3.jpg',
    ),
    MessageItem(
      userName: 'Robert Junior',
      lastMessage: 'Hello ',
      timeAgo: '2d ago',
      userAvatarAsset: 'images/avatar2.jpg',
    ),
    MessageItem(
      userName: 'Emma Watson',
      lastMessage: 'Tumhari yaad aa rhi thi',
      timeAgo: '3d ago',
      userAvatarAsset: 'images/avatar6.jpg',
      hasUnread: true,
    ),
    MessageItem(
      userName: 'Emily Hemsworth',
      lastMessage: 'Aaj meeting kar sakte hai?',
      timeAgo: '6d ago',
      userAvatarAsset: 'images/avatar5.jpg',
    ),
    MessageItem(
      userName: 'Rocky Watson',
      lastMessage: 'Hi, kal meeting hai ',
      timeAgo: '1w ago',
      userAvatarAsset: 'images/avatar3.jpg',
    ),
    MessageItem(
      userName: 'Cris Maxwell',
      lastMessage: 'Aaj baarish hogi',
      timeAgo: '1w ago',
      userAvatarAsset: 'images/avatar.jpg',
    ),
    MessageItem(
      userName: 'David Lynn',
      lastMessage: 'me thik hu',
      timeAgo: '2w ago',
      userAvatarAsset: 'images/avatar2.jpg',
      hasUnread: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(message.userAvatarAsset),
                      backgroundColor: Colors.grey.shade800,
                    ),
                    if (message.hasUnread)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.black, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.userName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message.lastMessage,
                        style: TextStyle(
                            color:
                            message.hasUnread ? Colors.white : Colors.grey,
                            fontSize: 13,
                            fontWeight: message.hasUnread
                                ? FontWeight.bold
                                : FontWeight.normal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  message.timeAgo,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
