import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Chat/controllers/chat_controller.dart';
import 'package:strife/Screens/Matching/components/choice_button.dart';
import 'package:strife/Screens/Matching/components/game_icon.dart';
import 'package:strife/Screens/Matching/controllers/matching_controller.dart';
import 'package:strife/models/user.dart';

class ViewFriendScreen extends StatelessWidget {
  const ViewFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
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
                          image: NetworkImage(chatController.friend.url),
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                  ),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  chatController.friend.age == 'Age' 
                    ? chatController.friend.gender == 'Hidden'
                      ? Text(chatController.friend.name, style: Theme.of(context).textTheme.headlineSmall)
                      : Text("${chatController.friend.name}, ${chatController.friend.gender}", style: Theme.of(context).textTheme.headlineSmall)
                    : chatController.friend.gender == 'Hidden'
                      ? Text("${chatController.friend.name}, ${chatController.friend.age}", style: Theme.of(context).textTheme.headlineSmall)
                      : Text("${chatController.friend.name}, ${chatController.friend.age}, ${chatController.friend.gender}", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 15.0),
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    chatController.friend.about,
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
                    chatController.friend.games!.length > 4 
                    ? chatController.friend.games!.getRange(0,4).map((game) =>
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
                    : chatController.friend.games!.getRange(0,chatController.friend.games!.length).map((game) =>
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
                          print("chatController.friend.uid");
                          print(chatController.friend.uid);
                          chatController.viewFriendGameScreen(chatController.friend.uid);
                      },
                      child: Container(
                        height: 30,
                        width: 150,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}