import 'package:cloud_firestore/cloud_firestore.dart';

class MessageContent {
  String uid;
  String content;
  Timestamp addtime;

  MessageContent({
    required this.uid,
    required this.content,
    required this.addtime,
  });

  factory MessageContent.fromMap(Map<String, dynamic> map) {
    return MessageContent(
      addtime: map['addtime'] ?? '',
      content: map['content'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}