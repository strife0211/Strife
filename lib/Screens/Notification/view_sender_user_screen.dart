import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Matching/components/choice_button.dart';
import 'package:strife/Screens/Matching/components/game_icon.dart';
import 'package:strife/Screens/Notification/controllers/notification_controller.dart';
import 'package:strife/Screens/Notification/notification_screen.dart';
import 'package:strife/models/user.dart';

class ViewSenderUserScreen extends StatelessWidget {
  final MyUser user;
  final int userIndex;

  const ViewSenderUserScreen({
    Key? key,
    required this.user,
    required this.userIndex
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: NetworkImage(user.url),
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // ChoiceButton(
                          //   width: 60,
                          //   height: 60,
                          //   size: 25,
                          //   hasGradient: false,
                          //   color: Theme.of(context).colorScheme.secondary,
                          //   icon: Icons.clear_rounded,
                          // ),
                          InkWell(
                            onTap: () async {
                              await notificationController.setFriendRequestStatus(userIndex, "accepted");
                              Get.back();
                            },
                            child: const ChoiceButton(
                              width: 80,
                              height: 80,
                              size: 30,
                              hasGradient: true,
                              color: Colors.white,
                              icon: Icons.add,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await notificationController.setFriendRequestStatus(userIndex, "decline");
                              Get.back();
                            },
                            child: ChoiceButton(
                              width: 80,
                              height: 80,
                              size: 30,
                              hasGradient: false,
                              color: Theme.of(context).colorScheme.secondary,
                              icon: Icons.cancel_outlined,
                            ),
                          ),
                          // ChoiceButton(
                          //   width: 60,
                          //   height: 60,
                          //   size: 25,
                          //   hasGradient: false,
                          //   color: Theme.of(context).colorScheme.secondary,
                          //   icon: Icons.watch_later,
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  user.age == 'Age' 
                    ? user.gender == 'Hidden'
                      ? Text(user.name, style: Theme.of(context).textTheme.headlineSmall)
                      : Text("${user.name}, ${user.gender}", style: Theme.of(context).textTheme.headlineSmall)
                    : user.gender == 'Hidden'
                      ? Text("${user.name}, ${user.age}", style: Theme.of(context).textTheme.headlineSmall)
                      : Text("${user.name}, ${user.age}, ${user.gender}", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 15.0),
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    user.about,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 2,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    'Recent Playing',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Column(
                    children: 
                    user.games!.length > 4 
                    ? user.games!.getRange(0,4).map((game) =>
                      Row(
                        children: [
                          GameIcon(game: game),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              right: 5.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).colorScheme.secondary,
                                ]
                              )
                            ),
                            child: Text(
                              '${game.name}',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ]
                      ),
                    ).toList()
                    : user.games!.getRange(0,user.games!.length).map((game) =>
                      Row(
                        children: [
                          GameIcon(game: game),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.only(
                              top: 5.0,
                              right: 5.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).colorScheme.secondary,
                                ]
                              )
                            ),
                            child: Text(
                              '${game.name}',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ]
                      ),
                    ).toList()
                  ),
                  const SizedBox(height: 10,),
                  Center(
                    child: GestureDetector(
                        onTap: () {
                        notificationController.viewSenderUserGameScreen(user.uid);
                      },
                      child: Container(
                        height: 30,
                        width: 150,
                        padding: const EdgeInsets.all(5.0),
                        // margin: const EdgeInsets.only(
                        //   top: 5.0,
                        //   right: 5.0,
                        // ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          // color: Colors.blue
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo,
                              Theme.of(context).colorScheme.secondary,
                            ]
                          )
                        ),
                        child: Text(
                          'View Game Owned',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: TextButton(
                  //     onPressed: () {
                  //       notificationController.viewSenderUserGameScreen(user.uid);
                  //     },
                  //     style: const ButtonStyle(
                  //       foregroundColor: MaterialStatePropertyAll(Colors.white),
                  //       backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  //     ),
                  //     child: Text(
                  //       "View Game Owned",
                  //       style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  //         color: Colors.white
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}