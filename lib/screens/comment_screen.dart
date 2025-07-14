import 'package:clone_tiktok/controller/comment_controller.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/widgets/comment_card.dart';
import 'package:clone_tiktok/widgets/comment_input_field.dart';
import 'package:clone_tiktok/widgets/custom_icon_button.dart';
import 'package:clone_tiktok/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key, required this.profileImage, required this.videoId});

  final String profileImage;
  final String videoId;
  final CommentController commentController = Get.put(CommentController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(videoId);

    return Scaffold(
      appBar: AppBar(title: Text('Comments'), backgroundColor: Colors.black),
      body: SizedBox(
        width: size.width,
        height: size.height - 100,
        child: Column(
          children: [
            // Displaying comments
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];

                    return CommentCard(
                      comment: comment,
                      onLike: () =>
                          commentController.likeComment(comment.commentId),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            // Comment input field
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: UserAvatar(imageUrl: profileImage, radius: 25),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CommentInputField(textController: textController),
                  ),
                ),
                CustomIconButton(
                  backgroundColor: primaryColor,
                  iconColor: Colors.white,
                  borderColor: Colors.white,
                  icon: Icons.arrow_upward,
                  buttonSize: 40,
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      commentController.postComment(textController.text);
                      textController.clear();
                    } else {
                      Get.snackbar('Error', 'Comment cannot be empty');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
