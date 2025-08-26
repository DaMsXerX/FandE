import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LikeController extends GetxController {
  Future<void> toggleLike(String postId, String currentUserId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final snapshot = await postRef.get();

    List likes = snapshot['likes'];

    if (likes.contains(currentUserId)) {
      await postRef.update({
        'likes': FieldValue.arrayRemove([currentUserId])
      });
    } else {
      await postRef.update({
        'likes': FieldValue.arrayUnion([currentUserId])
      });
    }
  }
}
