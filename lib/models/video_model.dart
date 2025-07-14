import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String username;
  String ownerId;
  String videoId;
  String videoUrl;
  String thumbnailUrl;
  String songName;
  String caption;
  String profileImage;
  DateTime datePublished;
  List likes;
  int commentCount;
  int shareCount;

  VideoModel({
    required this.username,
    required this.ownerId,
    required this.videoId,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.songName,
    required this.caption,
    required this.datePublished,
    required this.profileImage,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'ownerId': ownerId,
    'videoId': videoId,
    'videoUrl': videoUrl,
    'thumbnailUrl': thumbnailUrl,
    'songName': songName,
    'caption': caption,
    'datePublished': datePublished,
    'profileImage': profileImage,
    'likes': likes,
    'commentCount': commentCount,
    'shareCount': shareCount,
  };

  static VideoModel fromSnap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return VideoModel(
      username: data['username'],
      ownerId: data['ownerId'],
      videoId: data['videoId'],
      videoUrl: data['videoUrl'],
      thumbnailUrl: data['thumbnailUrl'],
      songName: data['songName'],
      caption: data['caption'],
      datePublished: data['datePublished'].toDate(),
      profileImage: data['profileImage'],
      likes: List.from(data['likes']),
      commentCount: data['commentCount'] ?? 0,
      shareCount: data['shareCount'] ?? 0,
    );
  }
}
