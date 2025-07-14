import 'package:clone_tiktok/controller/video_controller.dart';
import 'package:clone_tiktok/screens/comment_screen.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:clone_tiktok/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  // Using GetX for state management instead of StreamBuilder
  final VideoController _videoController = Get.put(VideoController());
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _videoController.videoList.isEmpty
            ? Center(child: Text('Currently no Videos to play'))
            : PageView.builder(
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemCount: _videoController.videoList.length,
                itemBuilder: (context, index) {
                  final videoData = _videoController.videoList[index];

                  return VideoWidget(
                    username: videoData.username,
                    profileImage: videoData.profileImage,
                    videoUrl: videoData.videoUrl,
                    caption: videoData.caption,
                    songName: videoData.songName,
                    datePublished: videoData.datePublished,
                    ownerId: videoData.ownerId,
                    videoId: videoData.videoId,
                    likes: videoData.likes,
                    commentCount: videoData.commentCount,
                    shareCount: videoData.shareCount,
                    onLike: () => _videoController.likeVideo(videoData.videoId),
                    onComment: () async {
                      final userModel = await _firebaseMethods.getUserDetails();
                      Get.to(
                        () => CommentScreen(
                          profileImage: userModel.profileImage,
                          videoId: videoData.videoId,
                        ),
                      );
                    },
                  );
                },
              );
      }),
    );
  }
}
