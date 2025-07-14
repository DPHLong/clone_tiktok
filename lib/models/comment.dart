import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String username; // username of the user who commented
  String videoId;
  String uid; // user id of the user who commented
  String commentId;
  String commentText;
  String profileImage; //image of the user who commented
  DateTime datePublished;
  List likes;

  Comment({
    required this.username,
    required this.videoId,
    required this.uid,
    required this.commentId,
    required this.commentText,
    required this.profileImage,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'videoId': videoId,
    'uid': uid,
    'commentId': commentId,
    'commentText': commentText,
    'profileImage': profileImage,
    'datePublished': datePublished,
    'likes': likes,
  };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      username: snapshot['username'],
      videoId: snapshot['videoId'],
      uid: snapshot['uid'],
      commentId: snapshot['commentId'],
      commentText: snapshot['commentText'],
      profileImage: snapshot['profileImage'],
      datePublished: snapshot['datePublished'].toDate(),
      likes: List.from(snapshot['likes']),
    );
  }
}
