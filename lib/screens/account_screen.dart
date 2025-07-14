import 'package:clone_tiktok/controller/auth_controller.dart';
import 'package:clone_tiktok/screens/login_screen.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:clone_tiktok/widgets/all_videos_view_widget.dart';
import 'package:clone_tiktok/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Using GetX for state management instead of StreamBuilder
  final AuthController _authController = Get.put(AuthController());
  final _firebaseMethods = FirebaseMethods();
  List<String> thumbnails = [];
  int likes = 0;

  getLikesAndThumbnails() async {
    final QuerySnapshot videos = await firestore
        .collection('videos')
        .where('ownerId', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    for (var i = 0; i < videos.docs.length; i++) {
      setState(() {
        thumbnails.add((videos.docs[i].data() as dynamic)['thumbnailUrl']);
        likes += ((videos.docs[i].data() as dynamic)['likes'] as List).length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLikesAndThumbnails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Account'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _firebaseMethods.logoutUser().whenComplete(() {
                Get.offAll(() => LoginScreen());
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        return _authController.userModel == null
            ? Center(child: Text('No profile was found'))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      UserAvatar(
                        imageUrl: _authController.userModel!.profileImage,
                        radius: 120,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _authController.userModel!.username,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),

                      Text(
                        _authController.userModel!.bio,
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 20,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Email: ${_authController.userModel!.email}',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${_authController.userModel!.followers.length}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Followers', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              Text(
                                '${_authController.userModel!.following.length}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Following', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          SizedBox(width: 16),
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
                      SizedBox(height: 8),
                      Text(
                        'Available Posts: ${_authController.userModel!.videos.length}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      AllVideosViewWidget(thumbnailUrls: thumbnails),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
