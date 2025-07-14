import 'package:clone_tiktok/models/comment.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  String _videoId = '';

  updatePostId(String videoId) {
    _videoId = videoId;
    getComment();
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        final userDoc = await firestore
            .collection('tiktokers')
            .doc(firebaseAuth.currentUser!.uid)
            .get();

        String commentId = Uuid().v1();
        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['username'],
          videoId: _videoId,
          uid: firebaseAuth.currentUser!.uid,
          commentId: commentId,
          commentText: commentText.trim(),
          profileImage: (userDoc.data()! as dynamic)['profileImage'],
          datePublished: DateTime.now(),
          likes: [],
        );
        await firestore
            .collection('videos')
            .doc(_videoId)
            .collection('comments')
            .doc(commentId)
            .set(comment.toJson());
        final videoDoc = await firestore
            .collection('videos')
            .doc(_videoId)
            .get();
        await firestore.collection('videos').doc(_videoId).update({
          'commentCount': (videoDoc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      debugPrint('--- Error posting comment: $e ---');
      Get.snackbar('Error', 'Failed to post comment');
      return;
    }
  }

  getComment() async {
    _comments.bindStream(
      firestore
          .collection('videos')
          .doc(_videoId)
          .collection('comments')
          .orderBy('datePublished', descending: true)
          .snapshots()
          .map((QuerySnapshot snapshot) {
            List<Comment> comments = [];
            for (var doc in snapshot.docs) {
              comments.add(Comment.fromSnap(doc));
            }
            return comments;
          }),
    );
  }

  likeComment(String commentId) async {
    try {
      final uid = firebaseAuth.currentUser!.uid;
      final commentDoc = await firestore
          .collection('videos')
          .doc(_videoId)
          .collection('comments')
          .doc(commentId)
          .get();
      if (commentDoc.exists) {
        List likes = (commentDoc.data()! as dynamic)['likes'] ?? [];
        if (likes.contains(uid)) {
          await firestore
              .collection('videos')
              .doc(_videoId)
              .collection('comments')
              .doc(commentId)
              .update({
                'likes': FieldValue.arrayRemove([uid]),
              });
        } else {
          await firestore
              .collection('videos')
              .doc(_videoId)
              .collection('comments')
              .doc(commentId)
              .update({
                'likes': FieldValue.arrayUnion([uid]),
              });
        }
      } else {
        Get.snackbar('Error', 'Comment not found');
      }
    } catch (e) {
      debugPrint('--- Error liking comment: $e ---');
      Get.snackbar('Error', 'Failed to like comment');
    }
  }
}
