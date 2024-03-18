import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Chat/chat_screen.dart';
import 'package:strife/Screens/Matching/controllers/matching_controller.dart';
import 'package:strife/Screens/Matching/matching_screen.dart';
import 'package:strife/Screens/Navigation/controllers/navigation_controller.dart';
import 'package:strife/Screens/Notification/notification_screen.dart';
import 'package:strife/Screens/Post/controllers/post_controller.dart';
import 'package:strife/Screens/Post/view_all_post_screen.dart';
import 'package:strife/Screens/Profile/controllers/profile_controller.dart';
import 'package:strife/Screens/Profile/profile_screen.dart';
import 'package:strife/constants.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final postController = Get.put(PostController());
    final navigationController = Get.put(NavigationController());
    final matchingController = Get.put(MatchingController());
    final profileController = Get.put(ProfileController());
    return GetBuilder<NavigationController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: navigationController.tabIndex,
              children: const [
                ViewAllPostScreen(),
                MatchingScreen(),
                NotificationScreen(),
                ChatScreen(),
                ProfileScreen(),
              ],
            )
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.indigo,
            unselectedItemColor: Color.fromARGB(255, 175, 175, 175),
            selectedItemColor: Colors.white,
            onTap: navigationController.changeTabInex,
            currentIndex: navigationController.tabIndex,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.feed),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_3_fill),
                label: 'Match',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
            ]
          ),
        );
      }
    );
  }
}