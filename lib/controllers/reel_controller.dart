import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReelController extends GetxController {
  RxList<QueryDocumentSnapshot> videos = <QueryDocumentSnapshot>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    FirebaseFirestore.instance
        .collection('posts')
        .where('fileType', isEqualTo: 'video')
        .snapshots()
        .listen((snapshot) {
      videos.value = snapshot.docs;
      isLoading.value = false;
    });
  }




}

