import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String content;
  Timestamp date;
  String userName;
  String url;
  String postID;

  Post({
    required this.content,
    required this.date,
    required this.userName,
    required this.url,
    required this.postID,
  });
}