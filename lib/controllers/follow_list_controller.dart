import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FollowListController extends GetxController {
  final String userId;
  final String type;

  FollowListController({required this.userId, required this.type});

  var usersList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers(); // auto-load users on init
  }

  Future<void> loadUsers() async {
    usersList.clear();

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(type); // type = 'followers' or 'following'

    final snapshot = await ref.get();

    for (var doc in snapshot.docs) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(doc.id)
          .get();
      if (userDoc.exists) {
        usersList.add(userDoc.data()!..['uid'] = userDoc.id);
      }
    }
  }
}
