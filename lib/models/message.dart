import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strife/models/message_content.dart';

class Message {
  String documentID;
  String? lastMessage;
  Timestamp? lastTime;
  String currentUserUid;
  String currentUserName;
  String currentUserImg;
  String userUid;
  String userName;
  String userImg;
  // MessageContent? messageContent;
  // Timestamp createdAt;
  // String message;
  // String userImg;
  // String userName;

  Message({
    required this.documentID,
    this.lastMessage,
    this.lastTime,
    required this.currentUserUid,
    required this.currentUserName,
    required this.currentUserImg,
    required this.userUid,
    required this.userName,
    required this.userImg,
    // this.messageContent,
    // required this.createdAt,
    // required this.message,
  });
}