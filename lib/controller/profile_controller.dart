import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;
  Rx<String> _uid = ''.obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData(uid);
  }

  getUserData(String uid) async {
    List<String> thumbnails = [];
    final QuerySnapshot videos = await firestore
        .collection('videos')
        .where('ownerId', isEqualTo: uid)
        .get();

    for (var i = 0; i < videos.docs.length; i++) {
      thumbnails.add((videos.docs[i].data() as dynamic)['thumbnailUrl']);
    }

    final DocumentSnapshot userDoc = await firestore
        .collection('tiktokers')
        .doc(uid)
        .get();
    final snapshot = userDoc.data() as Map<String, dynamic>;

    int likes = 0;
    List followers = snapshot['followers'];
    List following = snapshot['followings'];
    String name = snapshot['username'];
    String profileImage = snapshot['profileImage'];

    for (var i = 0; i < videos.docs.length; i++) {
      likes += ((videos.docs[i].data() as dynamic)['likes'] as List).length;
    }

    _user.value = {
      'followers': followers.length,
      'following': following.length,
      'likes': likes,
      'name': name,
      'profileImage': profileImage,
      'thumbnails': thumbnails,
    };
    update();
  }

  addFollower(String currentUserId) async {
    // current user will become this user's follower
    await firestore.collection('tiktokers').doc(_uid.value).update({
      'followers': FieldValue.arrayUnion([firebaseAuth.currentUser!.uid]),
    });
    await firestore.collection('tiktokers').doc(currentUserId).update({
      'following': FieldValue.arrayUnion([_uid.value]),
    });
  }

  removeFollower(String currentUserId) async {
    // current user is already this user's follower
    await firestore.collection('tiktokers').doc(_uid.value).update({
      'followers': FieldValue.arrayRemove([firebaseAuth.currentUser!.uid]),
    });
    await firestore.collection('tiktokers').doc(currentUserId).update({
      'following': FieldValue.arrayRemove([_uid.value]),
    });
  }
}
