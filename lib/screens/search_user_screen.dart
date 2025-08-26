import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fande/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class SearchUserScreen extends StatelessWidget {
  final String query;

  SearchUserScreen({required this.query});

  Future<List<DocumentSnapshot>> searchUsers(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('username', isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
        .get();

    return result.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: searchUsers(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found", style: TextStyle(color: Colors.white)));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user['profileImage'].isNotEmpty
                      ? NetworkImage(user['profileImage'])
                      : null,
                  backgroundColor: Colors.grey,
                  child: user['profileImage'].isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                title: Text(user['username'], style: const TextStyle(color: Colors.white)),
                subtitle: Text(user['name'], style: const TextStyle(color: Colors.grey)),
                onTap: () {
                  Get.to(() => UserProfileScreen(userId: user['uid']
                  ));

                }
                ,
              );
            },
          );
        },
      ),
    );
  }
}
