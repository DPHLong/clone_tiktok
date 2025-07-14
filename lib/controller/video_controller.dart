import 'package:clone_tiktok/controller/auth_controller.dart';
import 'package:clone_tiktok/models/video_model.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  final Rx<List<VideoModel>> _videoList = Rx<List<VideoModel>>([]);
  List<VideoModel> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
      firestore.collection('videos').snapshots().map((QuerySnapshot query) {
        List<VideoModel> retVal = [];
        for (var vid in query.docs) {
          retVal.add(VideoModel.fromSnap(vid));
        }
        return retVal;
      }),
    );
  }

  likeVideo(String videoId) async {
    try {
      DocumentSnapshot videoDoc = await firestore
          .collection('videos')
          .doc(videoId)
          .get();
      var uid = authController.user?.uid;
      if (videoDoc.exists && uid != null) {
        List likes = videoDoc['likes'];
        if (likes.contains(uid)) {
          // If already liked, remove like
          await firestore.collection('videos').doc(videoId).update({
            'likes': FieldValue.arrayRemove([uid]),
          });
        } else {
          // If not liked, add like
          await firestore.collection('videos').doc(videoId).update({
            'likes': FieldValue.arrayUnion([uid]),
          });
        }
      } else {
        Get.snackbar('Error', 'Video does not exist or user not authenticated');
      }
    } catch (e) {
      debugPrint('--- Error by liking video: $e ---');
      Get.snackbar('Error', 'Could not like the video');
    }
  }
}
