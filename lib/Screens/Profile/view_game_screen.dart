import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Profile/components/game_list.dart';
import 'package:strife/Screens/Profile/controllers/profile_controller.dart';
import 'package:strife/constants.dart';

// class ViewGameScreen extends StatelessWidget {
//   const ViewGameScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProfileController());
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: appBarPrimaryColor,
//         title: Text("View Game Owned"),
//         centerTitle: true,
//       ),
//       body: GetBuilder<ProfileController>(
//         builder: (_) {
//           return ListView.builder(
//             itemCount: controller.Games,
//             itemBuilder: (context, index) {
              
//             },
//             // children: [
//             //   ListTile(
//             //     leading: Image.network("http://media.steampowered.com/steamcommunity/public/images/apps/400/cfa928ab4119dd137e50d728e8fe703e4e970aff.jpg"),
//             //     title: Text("portal"),
//             //   )
//             // ],
//           );
//         }
//       )
//     );
//   }
// }

class ViewGameScreen extends StatefulWidget {
  const ViewGameScreen({super.key});

  @override
  State<ViewGameScreen> createState() => _ViewGameScreenState();
}

class _ViewGameScreenState extends State<ViewGameScreen> {
  final controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getGames();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appBarPrimaryColor,
        title: Text("View Game Owned"),
        centerTitle: true,
      ),
      body: Obx(() => controller.isDataLoadiang.value
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: controller.gamesList.length,
          itemBuilder: (context, index) {
            String image = '';
            String gameName = '';
            int appid = 0;
            String gameUrl = '';
            TimeOfDay playTime= controller.minutesToTimeOfDay(controller.gamesList[index].playtimeForever!);
            var lastPlay = DateTime.fromMillisecondsSinceEpoch(controller.gamesList[index].rtimeLastPlayed! * 1000);
            // DateTime lastPlayDate = lastPlay.toDate();

            try {
              image = controller.gamesList[index].imgIconUrl!;
              gameName = controller.gamesList[index].name!;
              appid = controller.gamesList[index].appid!;
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
              : Text(lastPlay.day.toString() + "/" + lastPlay.month.toString() + "/" + lastPlay.year.toString())
            );
          },
        )
      ),
      // body: Obx(() => controller.isDataLoadiang.value
      //   ? const Center(child: CircularProgressIndicator())
      //   : ListView.builder(
      //     itemCount: controller.games!.response!.gameCount,
      //     itemBuilder: (context, index) {
      //       String image = '';
      //       String title = '';
      //       int appid = 0;
      //       String gameUrl = '';
      //       TimeOfDay playTime= controller.minutesToTimeOfDay(controller.games!.response!.games![index].playtimeForever!);
      //       var lastPlay = DateTime.fromMillisecondsSinceEpoch(controller.games!.response!.games![index].rtimeLastPlayed! * 1000);
      //       // DateTime lastPlayDate = lastPlay.toDate();

      //       try {
      //         image = controller.games!.response!.games![index].imgIconUrl!;
      //         title = controller.games!.response!.games![index].name!;
      //         appid = controller.games!.response!.games![index].appid!;
      //         gameUrl = "http://media.steampowered.com/steamcommunity/public/images/apps/$appid/$image.jpg";
      //       } catch (e) {
      //         image = '';
      //         title = '';
      //         appid = 0;
      //         gameUrl = '';
      //       }

      //       print(gameUrl);

      //       return ListTile(
      //         leading: Image.network(gameUrl),
      //         title: Text(title),
      //         subtitle: Text(playTime.hour.toString() + " Hours " + playTime.minute.toString() + " Minutes"),
      //         trailing: lastPlay.year.isEqual(1970)
      //         ? Text("Never Play")
      //         : Text(lastPlay.year.toString() + "/" + lastPlay.month.toString() + "/" + lastPlay.day.toString())
      //       );
      //     },
      //   )
      // ),
      // body: GetBuilder<ProfileController>(
      //   builder: (_) {
      //     return ListView.builder(
      //       itemCount: controller.Games,
      //       itemBuilder: (context, index) {
              
      //       },
      //       // children: [
      //       //   ListTile(
      //       //     leading: Image.network("http://media.steampowered.com/steamcommunity/public/images/apps/400/cfa928ab4119dd137e50d728e8fe703e4e970aff.jpg"),
      //       //     title: Text("portal"),
      //       //   )
      //       // ],
      //     );
      //   }
      // )
    );
  }
}