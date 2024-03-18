import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:strife/Screens/Chat/controllers/message_controller.dart';
import 'package:strife/Screens/Chat/message_screen.dart';
import 'package:strife/Screens/Chat/view_friend_game_screen.dart';
import 'package:strife/Screens/Chat/view_friend_screen.dart';
import 'package:strife/models/message.dart';
import 'package:strife/models/message_content.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';
import 'package:strife/services/chat/chat_services.dart';

class ChatController extends GetxController {
  static ChatController get chat => Get.find();
  final messageController = Get.put(MessageController());

  late String currentUserUid;
  late List<Message> message;
  late List<MessageContent> messageContent;
  late String currentDocumentId;
  late MyUser friend;
  var isDataLoadiang = false.obs;
  late List<Games> gamesList;

  // RxList<Message> realTimeMessage = <Message>[].obs;
  // late Stream<List<Message>> realTimeMessage;
  late StreamSubscription<List<Message>> messageStreamSubscription;
  // RxList<Message> message = RxList<Message>([]);

  RxList<MessageContent> messageContent1 = RxList([]);

  // final textController = TextEditingController();
  // ScrollController messageController = ScrollController();

  // @override
  // void onInit() {
  //   super.onInit();
  //   print("===OnInit===");
  //   getMessage();
  // }

  // @override
  // void onClose() {
  //   print("===OnClose===");
  //   messageStreamSubscription.cancel();
  //   super.onClose();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  //   print("onReady");
  //   ChatService.chat.updateMessages(currentDocumentId);
  // }

  // void updateM() {
  //   print("update");
  //   ChatService.chat.updateMessages(currentDocumentId);
  //   update();
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   messageContent1.bindStream(ChatService.chat.updateMessages());
  // }

  // void updateMessageInController(MessageContent message) {
  //   // print("HELLO");
  //   messageContent.insert(0, message);
  //   messageContent.forEach((element) {
  //     print("element.content");
  //     print(element.content);
  //   });
  //   update();
  // }

  Future<void> getMessage() async {
    currentUserUid = await ChatService.chat.getCurrentUID();
    print("currentUserUid: " + currentUserUid);
    message = await ChatService.chat.getMessageData(currentUserUid);
    // Stream<List<Message>> realTimeMessage = await ChatService.chat.getRealTimeMessageData(currentUserUid);
    update();
  }

  // Future<void> getMessage() async {
  //   currentUserUid = await ChatService.chat.getCurrentUID();
  //   message = await ChatService.chat.getMessageData(currentUserUid);
  //   Stream<List<Message>> messageStream = ChatService.chat.getRealTimeMessageData(currentUserUid);
  //   print("===BeforeListen===");

  //   messageStreamSubscription = messageStream.listen((List<Message> messages) {
  //     print("===Listen===");
  //     message.clear();
  //     message.addAll(messages);
  //     update();
  //   });
  // }

  // Future<void> getMessage() async {
  //   currentUserUid = await ChatService.chat.getCurrentUID();
  //   Stream<List<Message>> messageStream = ChatService.chat.getRealTimeMessageData(currentUserUid);

  //   messageStreamSubscription =
  //       messageStream.listen((List<Message> messages) {
  //         print("Listen");
  //         message.clear();
  //         message.value = messages;
  //   });
  // }

  // Future<void> getMessage() async {
  //   String currentUserUid = await ChatService.chat.getCurrentUID();
  //   // message = await ChatService.chat.getMessageData(currentUserUid);
  //   Stream<List<Message>> messageStream = ChatService.chat.getRealTimeMessageData(currentUserUid);

  //   messageStream.listen((List<Message> messages) {
  //     print("Message");
  //     print(messages);
  //     message = messages;
  //     update();
  //   });
  // }

  // Future<void> sendMessage() async{
  //   String sendContent = textController.text;
  //   // final content = MessageContent(
  //   //   uid: currentUserUid,
  //   //   content: sendContent,
  //   //   addtime: Timestamp.now(),
  //   // );

  //   await ChatService.chat.sendMessages(currentDocumentId, currentUserUid, sendContent);

  //   textController.clear();
  // }

  // Future<void> toMessageScreen(int index) async {
  //   currentDocumentId = message[index].documentID;
  //   print("currentDocumentId in chat controller");
  //   print(currentDocumentId);
  //   messageContent = await ChatService.chat.readMessages(currentDocumentId);
  //   ChatService.chat.updateMessages(currentDocumentId);
  //   update();
  //   Get.to(() => MessageScreen(message: message[index]));
  // }

  Future<void> toMessageScreen(int index) async {
    currentDocumentId = message[index].documentID;
    print("currentDocumentId in chat controller");
    print(currentDocumentId);
    await MessageController.chat.updateDocumentID(currentDocumentId, currentUserUid);
    MessageController.chat.fetchMessages();
    // await MessageController.chat.updateMessage();
    // messageContent = await ChatService.chat.readMessages(currentDocumentId);
    // ChatService.chat.updateMessages(currentDocumentId);
    update();
    Get.to(() => MessageScreen(message: message[index]));
  }

  Future<void> viewFriendScreen(String userUid) async {
    friend = await ChatService.chat.getFriendData(userUid);
    update();
    Get.to(() => const ViewFriendScreen());
  }

  Future<void> viewFriendGameScreen(String uid) async {
    await getGames(uid);
    Get.to(() => const ViewFriendGameScreen());
  }

  TimeOfDay minutesToTimeOfDay(int minutes) {
      Duration duration = Duration(minutes: minutes);
      List<String> parts = duration.toString().split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> getGames(String uid) async {
    try {
      isDataLoadiang(true);

      gamesList = await ChatService.chat.getFriendOwnedGames(uid);
      update();
    } catch (e) {
      print("Error while getting data is $e");
    } finally {
      isDataLoadiang(false);
    }
  }
}