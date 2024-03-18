import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Chat/controllers/chat_controller.dart';
import 'package:strife/Screens/Matching/controllers/matching_controller.dart';
import 'package:strife/Screens/Profile/components/game_list.dart';
import 'package:strife/Screens/Profile/controllers/profile_controller.dart';
import 'package:strife/constants.dart';

class ViewFriendGameScreen extends StatelessWidget {
  const ViewFriendGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appBarPrimaryColor,
        title: Text("View Game Owned"),
        centerTitle: true,
      ),
      body: Obx(() => chatController.isDataLoadiang.value
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: chatController.gamesList.length,
          itemBuilder: (context, index) {
            String image = '';
            String gameName = '';
            int appid = 0;
            String gameUrl = '';
            TimeOfDay playTime= chatController.minutesToTimeOfDay(chatController.gamesList[index].playtimeForever!);
            var lastPlay = DateTime.fromMillisecondsSinceEpoch(chatController.gamesList[index].rtimeLastPlayed! * 1000);
            // DateTime lastPlayDate = lastPlay.toDate();

            try {
              image = chatController.gamesList[index].imgIconUrl!;
              gameName = chatController.gamesList[index].name!;
              appid = chatController.gamesList[index].appid!;
              gameUrl = "http://media.steampowered.com/steamcommunity/public/images/apps/$appid/$image.jpg";
            } catch (e) {
              image = '';
              gameName = '';
              appid = 0;
              gameUrl = '';
            }

            print(gameUrl);

            return ListTile(
              leading: Image.network(gameUrl),
              title: Text(gameName),
              subtitle: Text(playTime.hour.toString() + " Hours " + playTime.minute.toString() + " Minutes"),
              trailing: lastPlay.year.isEqual(1970)
              ? Text("Never Play")
              : Text(lastPlay.year.toString() + "/" + lastPlay.month.toString() + "/" + lastPlay.day.toString())
            );
          },
        )
      ),
    );
  }
}