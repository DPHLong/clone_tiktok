import 'package:clone_tiktok/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// Firebase global variables:
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

// Methods
class FirebaseMethods {
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'success';
    try {
      firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint('--- Error by by loging in: $e ---');
      Get.snackbar('Error by loging in', '$e');
      res = 'error';
    }
    return res;
  }

  Future<String> registerUser({
    required String email,
    required String password,
    required String username,
    String? bio,
    Uint8List? image,
  }) async {
    String res = 'success';
    try {
      String imgUrl = '';
      final UserCredential cred = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (image != null) {
        // upload image to firestore
        imgUrl = await uploadImageToStorage(
          image,
          'profile_images',
          cred.user!.uid,
        );
      }
      // create user doc in Firestore
      final UserModel user = UserModel(
        uid: cred.user!.uid,
        username: username,
        email: email,
        bio: bio ?? '',
        profileImage: imgUrl,
        followers: [],
        following: [],
        videos: [],
      );
      await firestore
          .collection('tiktokers')
          .doc(cred.user!.uid)
          .set(user.toJson());
    } catch (e) {
      debugPrint('--- Error by register: $e ---');
      Get.snackbar('Error by register', ' $e');
      res = 'error';
    }
    return res;
  }

  Future<void> logoutUser() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      debugPrint('--- Error by loging out: $e ---');
      Get.snackbar('Error by loging out', '$e');
    }
  }

  // get user's details from Firestore
  Future<UserModel> getUserDetails() async {
    final DocumentSnapshot snap = await firestore
        .collection('tiktokers')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    return UserModel.fromSnap(snap);
  }

  Future<String> uploadImageToStorage(
    Uint8List image,
    String folder,
    String imageId,
  ) async {
    try {
      final Reference ref = firebaseStorage.ref().child(folder).child(imageId);
      final UploadTask uploadTask = ref.putData(image);
      final TaskSnapshot snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint('--- Error uploading image: $e ---');
      Get.snackbar('Error uploading image', '$e');
      return '';
    }
  }
}
