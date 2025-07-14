import 'package:clone_tiktok/models/comment.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:clone_tiktok/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.comment, this.onLike});

  final Comment comment;
  final VoidCallback? onLike;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          UserAvatar(imageUrl: widget.comment.profileImage, radius: 22),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comment.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.comment.commentText,
                    style: TextStyle(color: Colors.grey),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        timeago.format(widget.comment.datePublished),
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${widget.comment.likes.length} likes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color:
                  widget.comment.likes.contains(firebaseAuth.currentUser!.uid)
                  ? primaryColor
                  : Colors.white,
            ),
            onPressed: () {
              if (widget.onLike != null) {
                widget.onLike!();
              }
            },
          ),
        ],
      ),
    );
  }
}
