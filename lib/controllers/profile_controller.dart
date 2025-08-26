// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class ProfileController extends GetxController {
//   final RxList<DocumentSnapshot> userPosts = <DocumentSnapshot>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserPosts();
//   }
//
//   void fetchUserPosts() {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//
//     FirebaseFirestore.instance
//         .collection('posts')
//         .where('userId', isEqualTo: userId)
//         // .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       userPosts.value = snapshot.docs;
//     });
//   }
// }

import 'dart:async';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  final RxList<DocumentSnapshot> userPosts = <DocumentSnapshot>[].obs;
  final RxMap<String, dynamic> userDetails = <String, dynamic>{}.obs;

  final RxInt followersCount = 0.obs;
  final RxInt followingCount = 0.obs;

  late final String userId;

  // Firestore subscription references to manage listeners properly
  late final StreamSubscription postsSubscription;
  late final StreamSubscription followersSubscription;
  late final StreamSubscription followingSubscription;

  @override
  void onInit() {
    super.onInit();

    userId = FirebaseAuth.instance.currentUser!.uid;

    fetchUserDetails();

    // Setup Firestore listeners once, avoid multiple subscriptions
    postsSubscription = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      userPosts.value = snapshot.docs;
    });

    followersSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('followers')
        .snapshots()
        .listen((snapshot) {
      followersCount.value = snapshot.docs.length;
    });

    followingSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('following')
        .snapshots()
        .listen((snapshot) {
      followingCount.value = snapshot.docs.length;
    });
  }

  void fetchUserDetails() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.exists) {
      userDetails.value = doc.data()!;
    } else {
      userDetails.value = {
        'username': 'Unknown',
        'email': '',
        'profileImage': ''
      };
    }
  }

  @override
  void onClose() {
    // Cancel all subscriptions when controller is disposed
    postsSubscription.cancel();
    followersSubscription.cancel();
    followingSubscription.cancel();
    super.onClose();
  }
}
