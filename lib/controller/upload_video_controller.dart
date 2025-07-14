import 'dart:io';
import 'package:clone_tiktok/models/video_model.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  // This controller will handle the video upload logic
  // You can add methods to upload the video to a server or cloud storage

  Future<File> _getThumbnail(String videoPath) async {
    // Logic to generate a thumbnail from the video
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    String videoUrl = '';
    try {
      final ref = firebaseStorage.ref().child('videos').child(id);
      final compressedVideo = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.MediumQuality,
      );
      if (compressedVideo == null) {
        throw Exception('Video compression failed');
      } else {
        UploadTask uploadTask = ref.putFile(compressedVideo.file!);
        TaskSnapshot snapshot = await uploadTask;
        videoUrl = await snapshot.ref.getDownloadURL();
      }
    } catch (e) {
      debugPrint('--- Error by uploading video: $e ---');
      Get.snackbar('Error', 'Failed to upload video: $e');
    }
    return videoUrl;
  }

  Future<String> _uploadThumbnailToStorage(String id, String videoPath) async {
    String thumbnailUrl = '';
    try {
      final ref = firebaseStorage.ref().child('thumbnails').child(id);
      final thumbnail = await _getThumbnail(videoPath);
      UploadTask uploadTask = ref.putFile(thumbnail);
      TaskSnapshot snapshot = await uploadTask;
      thumbnailUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('--- Error by uploading thumbnail: $e ---');
      Get.snackbar('Error', 'Failed to upload thumbnail: $e');
    }
    return thumbnailUrl;
  }

  Future<void> uploadVideo(
    String songName,
    String caption,
    String videoPath,
  ) async {
    try {
      final uid = firebaseAuth.currentUser!.uid;
      final userDoc = await firestore.collection('tiktokers').doc(uid).get();
      final String videoId = Uuid().v1();
      final String videoUrl = await _uploadVideoToStorage(videoId, videoPath);
      final String thumbnailUrl = await _uploadThumbnailToStorage(
        videoId,
        videoPath,
      );
      // Create a video model instance
      final videoModel = VideoModel(
        username: (userDoc.data() as Map<String, dynamic>)['username'],
        ownerId: uid,
        videoId: videoId,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        songName: songName,
        caption: caption,
        datePublished: DateTime.now(),
        profileImage: (userDoc.data() as Map<String, dynamic>)['profileImage'],
        likes: [],
        commentCount: 0,
        shareCount: 0,
      );

      await firestore
          .collection('videos')
          .doc(videoId)
          .set(videoModel.toJson());
      await firestore.collection('tiktokers').doc(uid).update({
        'videos': FieldValue.arrayUnion([videoId]),
      });
      Get.snackbar('Success', 'Video uploaded successfully');
    } catch (e) {
      debugPrint('--- Error by uploading video $e ---');
      Get.snackbar('Failed to upload video', '$e');
    }
  }
}
