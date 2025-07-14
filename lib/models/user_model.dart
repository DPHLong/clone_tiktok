import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.profileImage,
    required this.followers,
    required this.following,
    required this.videos,
  });

  final String uid;
  final String username;
  final String email;
  final String bio;
  final String profileImage;
  final List followers;
  final List following;
  final List videos;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'email': email,
    'bio': bio,
    'profileImage': profileImage,
    'followers': [],
    'following': [],
    'videos': [],
  };

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      username: data['username'],
      email: data['email'],
      bio: data['bio'],
      profileImage: data['profileImage'],
      followers: data['followers'],
      following: data['following'],
      videos: data['videos'],
    );
  }
}
