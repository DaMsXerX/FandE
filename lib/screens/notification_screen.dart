// import 'package:flutter/material.dart';
//
// // --- Data Model for Notifications ---
// class NotificationItem {
//   final String userName;
//   final String action;
//   final String timeAgo;
//   final String userAvatarUrl;
//   final String? contentThumbnailUrl; // Optional: for liked/commented video thumbnail
//
//   const NotificationItem({
//     required this.userName,
//     required this.action,
//     required this.timeAgo,
//     required this.userAvatarUrl,
//     this.contentThumbnailUrl,
//   });
// }
//
// // --- Notification Screen Widget ---
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({Key? key}) : super(key: key);
//
//   // Sample data for Notifications
//   // In a real application, this data would come from an API call or a state management solution.
//   final List<NotificationItem> _notifications = const [
//     NotificationItem(
//       userName: 'Robert Junior',
//       action: 'liked your video',
//       timeAgo: '7m ago',
//       userAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/avatars%2Fmale1.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//       contentThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/content_thumbnails%2Fdance_thumbnail1.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//     ),
//     NotificationItem(
//       userName: 'Don Hart',
//       action: 'liked your video',
//       timeAgo: '7m ago',
//       userAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/avatars%2Fmale2.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//       contentThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/content_thumbnails%2Fdance_thumbnail2.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//     ),
//     NotificationItem(
//       userName: 'Emili Williamson',
//       action: 'commented on your video',
//       timeAgo: '8m ago',
//       userAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/avatars%2Ffemale1.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//       contentThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/content_thumbnails%2Fdance_thumbnail3.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//     ),
//     NotificationItem(
//       userName: 'Ema Watson',
//       action: 'commented on your video',
//       timeAgo: '9m ago',
//       userAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/avatars%2Ffemale2.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//       contentThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/content_thumbnails%2Fdance_thumbnail4.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//     ),
//     NotificationItem(
//       userName: 'Rosy Gold',
//       action: 'liked your video',
//       timeAgo: '11m ago',
//       userAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/avatars%2Ffemale3.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//       contentThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/content_thumbnails%2Fdance_thumbnail5.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//     ),
//     NotificationItem(
//       userName: 'Robert Junior',
//       action: 'commented on your video',
//       timeAgo: '13m ago',
//       userAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/avatars%2Fmale1.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//       contentThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/content_thumbnails%2Fdance_thumbnail6.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//     ),
//     NotificationItem(
//       userName: 'Emili Williamson',
//       action: 'liked your video',
//       timeAgo: '15m ago',
//       userAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/avatars%2Ffemale1.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//       contentThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/content_thumbnails%2Fdance_thumbnail7.jpeg?alt=media&token=4a5957b1-2131-4874-9844-31b265814529',
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black, // Consistent dark background
//       appBar: AppBar(
//         backgroundColor: Colors.black, // Dark app bar background
//         elevation: 0, // No shadow
//         title: const Text(
//           'Notifications',
//           style: TextStyle(color: Colors.white), // White title text
//         ),
//         centerTitle: true, // Center the title
//         // If this screen is pushed onto a stack, a back button will automatically appear.
//         // If it's a root screen, you might set automaticallyImplyLeading: false.
//       ),
//       body: ListView.builder(
//         itemCount: _notifications.length,
//         itemBuilder: (context, index) {
//           final notification = _notifications[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: Row(
//               children: [
//                 // User Avatar
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundImage: NetworkImage(notification.userAvatarUrl),
//                   backgroundColor: Colors.grey.shade800, // Fallback background color
//                 ),
//                 const SizedBox(width: 12),
//                 // Notification Text
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         notification.userName,
//                         style: const TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         '${notification.action} . ${notification.timeAgo}',
//                         style: const TextStyle(color: Colors.grey, fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Optional Content Thumbnail
//                 if (notification.contentThumbnailUrl != null)
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: Image.network(
//                       notification.contentThumbnailUrl!,
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           width: 50,
//                           height: 50,
//                           color: Colors.grey.shade700,
//                           child: const Icon(Icons.broken_image, color: Colors.white54),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


//code is working
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottom_nav_bar.dart';
import 'chat_list_screen.dart';
import 'message_screen.dart';

class NotificationItem {
  final String userName;
  final String action;
  final String timeAgo;
  final String userAvatarAsset;
  final String? contentThumbnailAsset;

  const NotificationItem({
    required this.userName,
    required this.action,
    required this.timeAgo,
    required this.userAvatarAsset,
    this.contentThumbnailAsset,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  final List<NotificationItem> _notifications = const [
    NotificationItem(
      userName: 'Robert Junior',
      action: 'liked your video',
      timeAgo: '7m ago',
      userAvatarAsset: 'images/avatar.jpg',

    ),
    NotificationItem(
      userName: 'Don Hart',
      action: 'liked your video',
      timeAgo: '7m ago',
      userAvatarAsset: 'images/avatar2.jpg',

    ),
    NotificationItem(
      userName: 'Emili Williamson',
      action: 'commented on your video',
      timeAgo: '8m ago',
      userAvatarAsset: 'images/avatar3.jpg',

    ),
    NotificationItem(
      userName: 'Ema Watson',
      action: 'commented on your video',
      timeAgo: '9m ago',
      userAvatarAsset: 'images/avatar2.jpg',

    ),
    NotificationItem(
      userName: 'Rosy Gold',
      action: 'liked your video',
      timeAgo: '11m ago',
      userAvatarAsset: 'images/avatar.jpg',

    ),
    NotificationItem(
      userName: 'Robert Junior',
      action: 'commented on your video',
      timeAgo: '13m ago',
      userAvatarAsset: 'images/avatar3.jpg',

    ),
    NotificationItem(
      userName: 'Emili Williamson',
      action: 'liked your video',
      timeAgo: '15m ago',
      userAvatarAsset: 'images/avatar2.jpg',

    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_rounded, color: Colors.white),
            onPressed: () {
              Get.to(() =>  ChatListScreen());
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(notification.userAvatarAsset),
                  backgroundColor: Colors.grey.shade800,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.userName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('${notification.action} • ${notification.timeAgo}',
                          style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                if (notification.contentThumbnailAsset != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        notification.contentThumbnailAsset!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey.shade700,
                            child: const Icon(Icons.broken_image, color: Colors.white54),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}


