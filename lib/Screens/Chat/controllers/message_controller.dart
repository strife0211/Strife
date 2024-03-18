import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strife/models/message_content.dart';
import 'package:strife/services/chat/chat_services.dart';

class MessageController extends GetxController {
  static MessageController get chat => Get.find();
  // RxList<MessageContent> messageContent1 = RxList([]);
  RxList<MessageContent> messageContent1 = <MessageContent>[].obs;
  late String currentUserUid;
  late String currentDocumentID;

  final textController = TextEditingController();
  ScrollController scrollController = ScrollController();


  // @override
  // void onReady() {
  //   super.onReady();
  //   messageContent1.bindStream(ChatService.chat.updateMessages(currentDocumentID));
  // }

  // updateMessage() {
  //   messageContent1.bindStream(ChatService.chat.updateMessages(currentDocumentID));
  // }

  void fetchMessages() {
    // Assuming you have a reference to Firestore or any other database
    // Replace the following code with your own implementation to fetch messages

    // Example code to fetch messages from Firestore
    FirebaseFirestore.instance
        .collection('chat')
        .doc(currentDocumentID)
        .collection('messageList')
        .orderBy("addtime", descending: true)
        .snapshots()
        .listen((snapshot) {
          messageContent1.clear();
          messageContent1.value = snapshot.docs.map((doc) => MessageContent.fromMap(doc.data())).toList();
    });
  }

  updateDocumentID(String documentID, String userUID) {
    currentDocumentID = documentID;
    currentUserUid = userUID;
    update();
  }

  Future<void> sendMessage() async{
    String sendContent = textController.text;

    await ChatService.chat.sendMessages(currentDocumentID, currentUserUid, sendContent);

    textController.clear();
  }
}