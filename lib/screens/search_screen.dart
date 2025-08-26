// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<DocumentSnapshot> _results = [];
//
//   void _searchUser(String query) async {
//     final result = await FirebaseFirestore.instance
//         .collection('users')
//         .where('username', isGreaterThanOrEqualTo: query)
//         .where('username', isLessThan: '${query}z')
//         .get();
//
//     setState(() {
//       _results = result.docs;
//     });
//   }
//
//   Future<void> _followUser(String targetUserId) async {
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;
//
//     final currentUserRef =
//     FirebaseFirestore.instance.collection('users').doc(currentUserId);
//     final targetUserRef =
//     FirebaseFirestore.instance.collection('users').doc(targetUserId);
//
//     await currentUserRef.update({
//       'following': FieldValue.arrayUnion([targetUserId])
//     });
//
//     await targetUserRef.update({
//       'followers': FieldValue.arrayUnion([currentUserId])
//     });
//   }
//
//   bool _isFollowing(List following, String targetUserId) {
//     return following.contains(targetUserId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Users'),
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: _searchUser,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Search username',
//                 hintStyle: const TextStyle(color: Colors.grey),
//                 filled: true,
//                 fillColor: Colors.grey[900],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 prefixIcon: const Icon(Icons.search, color: Colors.white),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _results.length,
//               itemBuilder: (context, index) {
//                 final user = _results[index];
//                 final targetUserId = user.id;
//
//                 return FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance.collection('users').doc(currentUserId).get(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) return const SizedBox();
//
//                     final following = snapshot.data!['following'] ?? [];
//
//                     final isFollowing = _isFollowing(following, targetUserId);
//
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(user['profilePic']),
//                       ),
//                       title: Text(user['username'], style: const TextStyle(color: Colors.white)),
//                       trailing: isFollowing
//                           ? const Text("Following", style: TextStyle(color: Colors.green))
//                           : TextButton(
//                         onPressed: () => _followUser(targetUserId),
//                         child: const Text("Follow"),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
