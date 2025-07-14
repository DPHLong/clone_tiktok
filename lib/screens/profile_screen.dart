import 'package:clone_tiktok/models/user_model.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:clone_tiktok/widgets/all_videos_view_widget.dart';
import 'package:clone_tiktok/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> thumbnails = [];
  int likes = 0;
  bool didFollow = true;

  getLikesAndThumbnails() async {
    final QuerySnapshot videos = await firestore
        .collection('videos')
        .where('ownerId', isEqualTo: widget.user.uid)
        .get();

    for (var i = 0; i < videos.docs.length; i++) {
      setState(() {
        thumbnails.add((videos.docs[i].data() as dynamic)['thumbnailUrl']);
        likes += ((videos.docs[i].data() as dynamic)['likes'] as List).length;
      });
    }
  }

  toggleFollowStatus() async {
    if (widget.user.followers.contains(firebaseAuth.currentUser!.uid)) {
      setState(() => didFollow = true);
    } else {
      setState(() => didFollow = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getLikesAndThumbnails();
    toggleFollowStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: didFollow
            ? IconButton(
                onPressed: () async {
                  // current user is already this user's follower
                  await firestore
                      .collection('tiktokers')
                      .doc(widget.user.uid)
                      .update({
                        'followers': FieldValue.arrayRemove([
                          firebaseAuth.currentUser!.uid,
                        ]),
                      });
                  await firestore
                      .collection('tiktokers')
                      .doc(firebaseAuth.currentUser!.uid)
                      .update({
                        'following': FieldValue.arrayRemove([widget.user.uid]),
                      });
                  toggleFollowStatus();
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.person_remove_alt_1),
              )
            : IconButton(
                onPressed: () async {
                  // current user will become this user's follower
                  await firestore
                      .collection('tiktokers')
                      .doc(widget.user.uid)
                      .update({
                        'followers': FieldValue.arrayUnion([
                          firebaseAuth.currentUser!.uid,
                        ]),
                      });
                  await firestore
                      .collection('tiktokers')
                      .doc(firebaseAuth.currentUser!.uid)
                      .update({
                        'following': FieldValue.arrayUnion([widget.user.uid]),
                      });
                  toggleFollowStatus();
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.person_add_alt_1),
              ),
        title: Text(widget.user.username),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //TODO: some more actions
            },
            icon: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            UserAvatar(imageUrl: widget.user.profileImage, radius: 100),
            const SizedBox(height: 10),
            Text(
              widget.user.bio,
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 20,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.user.followers.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Followers', style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      '${widget.user.following.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Following', style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      '$likes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Likes', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Available Posts: ${widget.user.videos.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            AllVideosViewWidget(thumbnailUrls: thumbnails),
          ],
        ),
      ),
    );
  }
}
