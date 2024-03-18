import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Notification/view_sender_user_game_screen.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';
import 'package:strife/services/notification/notification_services.dart';

class NotificationController extends GetxController {
  static NotificationController get notification => Get.find();

  late String currentUserUid;
  late List<MyUser> senderUserDataList;
  late List<MyUser> receiverUserDataList;

  late List<Games> gamesList;
  var isDataLoadiang = false.obs;

  Future<void> setFriendRequestStatus(int index, String status) async {
    print("senderUserDataList[index].uid");
    print(senderUserDataList[index].uid);
    await NotificationService.notification.setFriendRequestStatus(currentUserUid, senderUserDataList[index], status);
    senderUserDataList.removeAt(index);
    update();
    print("senderUserDataList");
    print(senderUserDataList);
  }

  Future<void> readReceiverAndSenderUserDatalist() async {
    await readSenderUserDataList();
    await readReceiverUserDataList();
  }

  Future<void> readSenderUserDataList() async {
    currentUserUid = await NotificationService.notification.getCurrentUID();
    print("currentUserUid: " + currentUserUid);
    senderUserDataList = await NotificationService.notification.getSenderUserDataList(currentUserUid);
    update();
    // print("senderUserDataList[0].name");
    // print(senderUserDataList[0].name);
  }

  Future<void> readReceiverUserDataList() async {
    currentUserUid = await NotificationService.notification.getCurrentUID();
    print("currentUserUid: " + currentUserUid);
    receiverUserDataList = await NotificationService.notification.getReceiverUserDataList(currentUserUid);
    update();
    print("receiverUserDataList[0].name");
    print(receiverUserDataList[0].name);
  }

  Future<void> viewSenderUserGameScreen(String uid) async {
    await getGames(uid);
    Get.to(() => const ViewSenderUserGameScreen());
  }

  Future<void> getGames(String uid) async {
    try {
      isDataLoadiang(true);

      gamesList = await NotificationService.notification.getUserOwnedGames(uid);
      update();

      // print("gameList length: ");
      // print(gamesList.length);

    } catch (e) {
      print("Error while getting data is $e");
    } finally {
      isDataLoadiang(false);
    }
  }

  TimeOfDay minutesToTimeOfDay(int minutes) {
      Duration duration = Duration(minutes: minutes);
      List<String> parts = duration.toString().split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}