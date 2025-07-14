import 'package:clone_tiktok/controller/auth_controller.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/widgets/circle_animation.dart';
import 'package:clone_tiktok/widgets/custom_icon_button.dart';
import 'package:clone_tiktok/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    super.key,
    required this.username,
    required this.profileImage,
    required this.videoUrl,
    required this.caption,
    required this.songName,
    required this.datePublished,
    required this.ownerId,
    required this.videoId,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  final String username; // username of Post's owner
  final String profileImage; // image of Post's Owner
  final String videoUrl;
  final String caption;
  final String songName;
  final String ownerId; // uid of user, who posted
  final String videoId;
  final DateTime datePublished;
  final List<dynamic> likes;
  final int commentCount; // number of comments on the video
  final int shareCount; // number of shares of the video
  final VoidCallback? onLike; // callback for like action
  final VoidCallback? onComment; // callback for comment action
  final VoidCallback? onShare; // callback for share action

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((value) {
            _videoController.play();
            _videoController.setVolume(1.0);
          });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Video player at background
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(color: mobileBackgroundColor),
          child: VideoPlayer(_videoController),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Video details section
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.username,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.caption,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.music_note, color: Colors.white),
                          Text(
                            widget.songName,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Icon buttons section
              Container(
                height: size.height / 2,
                margin: EdgeInsets.only(top: size.height / 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 65,
                      child: Stack(
                        children: [
                          UserAvatar(imageUrl: widget.profileImage, radius: 25),
                          Positioned(
                            bottom: -10,
                            right: 7,
                            child: CustomIconButton(
                              icon: Icons.add,
                              backgroundColor: primaryColor,
                              iconColor: Colors.white,
                              borderColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => widget.onLike?.call(),
                          child: Icon(
                            Icons.favorite,
                            color:
                                widget.likes.contains(authController.user!.uid)
                                ? Colors.red
                                : Colors.white,
                            size: 40,
                          ),
                        ),
                        Text(widget.likes.length.toString()),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => widget.onComment?.call(),
                          child: Icon(Icons.chat, size: 40),
                        ),
                        Text('${widget.commentCount}'),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => widget.onComment?.call(),
                          child: Icon(Icons.reply, size: 40),
                        ),
                        Text('${widget.shareCount}'),
                      ],
                    ),
                    CircleAnimation(
                      child: UserAvatar(
                        imageUrl: widget.profileImage,
                        radius: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
