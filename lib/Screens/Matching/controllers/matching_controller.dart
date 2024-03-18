import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Matching/matching_screen.dart';
import 'package:strife/Screens/Matching/view_user_game_screen.dart';
import 'package:strife/Screens/Navigation/navigation.dart';
import 'package:strife/Screens/Notification/controllers/notification_controller.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';
import 'package:strife/services/matching/matching_services.dart';

class MatchingController extends GetxController {
  static MatchingController get matching => Get.find();
  static NotificationController get notification => Get.find();

  MyUser emptyUser = MyUser(uid: "", name: "Empty User", email: "", gender: "", age: 0, address: "", phone: "", steamID: "", url: "", about: "",games: [], sameGames: [], friends: []);
  late List<MyUser> userDataList;

  late String currentUserUid;

  late List<Games> gamesList;
  var isDataLoadiang = false.obs;

  List<bool> selectedGender = [true, false];
  List<String> genderTextList = ["Male", "Female"];
  String gender = "Male";
  // List<bool> selectedGame = [true, false, false];
  // List<String> gameTextList = ["Recent Game Played", "Longest Game Played", "Same Game Played"];
  List<String> gameTextList = ["Recent", "Longest", "Same"];
  String game = "Recent";

  RangeValues values = RangeValues(0, 100);
  RangeLabels labels = RangeLabels(0.toString(), 100.toString());

  Future<void> sendRequest(String userUid) async {
    print(userUid);
    await MatchingService.matching.createRequest(currentUserUid, userUid);
    await NotificationController.notification.readSenderUserDataList();
    SwipeLeft();
  }

  void setGenderIndex(int index) {
    for (int i = 0; i < selectedGender.length; i++) {
      selectedGender[i] = i == index;
    }
    if(selectedGender[0]) {
      gender = "Male";
    }
    else {
      gender = "Female";
    }
    update();
    print("gender");
    print(gender);
    print("selectedGender");
    print(selectedGender);
  }

  // void setGameIndex(int index) {
  //   for (int i = 0; i < selectedGame.length; i++) {
  //     selectedGame[i] = i == index;
  //   }
  //   update();
  //   print("selectedGame");
  //   print(selectedGame);
  // }

  void setGame(String Game) {
    game = Game;
    update();
    print("game");
    print(game);
  }

  void setRange(RangeValues values) {
    this.values = values;
    labels = RangeLabels(values.start.round().toString(), values.end.round().toString());
    print('Start and End');
    print('${this.values.start.round().toString()}, ${this.values.end.round().toString()}');
    update();
  }

  void SwipeLeft() {
    userDataList.removeAt(0);
    update();
  }

  void SwipeRight() {
    userDataList.removeAt(0);
    update();
  }

  Future<void> getUserList() async {
    currentUserUid = await MatchingService.matching.getCurrentUID();
    print("currentUserUid: " + currentUserUid);
    userDataList = await MatchingService.matching.getUserDataList(currentUserUid);
    // print("userDataList[0].name");
    // print(userDataList[0].name);
    // print("userDataList[1].name");
    // print(userDataList[1].name);
    // print("userDataList[0].games![0].appid");
    // print(userDataList[0].games![0].appid);
    // print("userDataList[0].games![1].appid");
    // print(userDataList[0].games![1].appid);
    update();
  }

  Future<void> filter() async {
    currentUserUid = await MatchingService.matching.getCurrentUID();
    print("currentUserUid: " + currentUserUid);
    userDataList = await MatchingService.matching.getFilterUserDataList(currentUserUid, gender, values.start.round(), values.end.round(), game);
    print("userDataList[0].name");
    print(userDataList[0].name);
    update();
    Get.to(() => const NavigationScreen());
  }

  Future<void> viewUserGameScreen(String uid) async {
    await getGames(uid);
    Get.to(() => const ViewUserGameScreen());
  }

  Future<void> getGames(String uid) async {
    try {
      isDataLoadiang(true);

      gamesList = await MatchingService.matching.getUserOwnedGames(uid);
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