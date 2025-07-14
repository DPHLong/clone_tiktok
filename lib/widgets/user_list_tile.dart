import 'package:clone_tiktok/models/user_model.dart';
import 'package:clone_tiktok/screens/profile_screen.dart';
import 'package:clone_tiktok/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(imageUrl: user.profileImage, radius: 25),
      title: Text(
        user.username,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        'Followers: ${user.followers.length}',
        style: TextStyle(color: Colors.grey),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.favorite, color: Colors.white),
      ),
      onTap: () {
        Get.to(() => ProfileScreen(user: user));
      },
    );
  }
}
