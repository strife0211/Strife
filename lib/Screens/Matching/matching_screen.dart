import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Matching/components/choice_button.dart';
import 'package:strife/Screens/Matching/components/empty_user_card.dart';
import 'package:strife/Screens/Matching/components/user_card.dart';
import 'package:strife/Screens/Matching/controllers/matching_controller.dart';
import 'package:strife/Screens/Matching/filter_user_screen.dart';
import 'package:strife/Screens/Matching/view_user_screen.dart';
import 'package:strife/constants.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matchingController = Get.put(MatchingController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        // backgroundColor: appBarPrimaryColor,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset("assets/images/Strife_Logos.png")
            ),
            Expanded(
              flex: 1,
              child: Container()),
            Expanded(
              flex: 4,
              child: Text(
                "DISCOVER",
                style: Theme.of(context).textTheme.headlineMedium,
              )
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Get.to(() => FilterUserScreen())
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () { matchingController.getUserList(); }
          )
        ],
      ),
      // body: Container(
      //   child: ElevatedButton(
      //     child: Container(child: Text("Press"),),
      //     onPressed: () {
      //       matchingController.getUserList();
      //     },
      //     ),
      // ),
      body: Column(
        children: [
          GetBuilder<MatchingController>(builder: (_) { 
            return 
            matchingController.userDataList.isEmpty
            ? const EmptyUserCard()
            : InkWell(
              onTap: () {
                Get.to(() => ViewUserScreen(user: matchingController.userDataList[0]));
              },
              child: Draggable(
                feedback: UserCard(
                  user: matchingController.userDataList[0]
                ),
                childWhenDragging: matchingController.userDataList.length == 1
                  ? UserCard(
                    user: matchingController.userDataList[0]
                  )
                  : UserCard(
                    user: matchingController.userDataList[1]
                  ),
                child: UserCard(
                  user: matchingController.userDataList[0]
                ),
                onDragEnd: (drag) {
                  if (drag.velocity.pixelsPerSecond.dx < 0) {
                    matchingController.SwipeLeft();
                    print('Swiped left');
                  } else {
                    matchingController.SwipeRight();
                    print('Swiped right');
                  }
                },
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 60,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    matchingController.SwipeLeft();
                  },
                  child: ChoiceButton(
                    width: 60,
                    height: 60,
                    size: 25,
                    hasGradient: false,
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icons.clear_rounded,
                  ),
                ),
                InkWell(
                  onTap: () {
                    matchingController.sendRequest(matchingController.userDataList[0].uid);
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
                  onTap: () {
                    Get.to(() => ViewUserScreen(user: matchingController.userDataList[0]));
                  },
                  child: ChoiceButton(
                    width: 60,
                    height: 60,
                    size: 25,
                    hasGradient: false,
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icons.search,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class MatchingScreen extends StatefulWidget {
//   const MatchingScreen({super.key});

//   @override
//   State<MatchingScreen> createState() => _MatchingScreenState();
// }

// class _MatchingScreenState extends State<MatchingScreen> {
//   final matchingController = Get.put(MatchingController());

//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   matchingController.getUserList();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         // backgroundColor: appBarPrimaryColor,
//         elevation: 0,
//         title: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Image.asset("assets/images/Strife_Logos.png")
//             ),
//             Expanded(
//               flex: 1,
//               child: Container()),
//             Expanded(
//               flex: 4,
//               child: Text(
//                 "DISCOVER",
//                 style: Theme.of(context).textTheme.headlineMedium,
//               )
//             )
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.message,
//               color: Theme.of(context).primaryColor,
//             ),
//             onPressed: () {}
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.refresh,
//               color: Theme.of(context).primaryColor,
//             ),
//             onPressed: () {matchingController.getUserList();}
//           )
//         ],
//       ),
//       // body: Container(
//       //   child: ElevatedButton(
//       //     child: Container(child: Text("Press"),),
//       //     onPressed: () {
//       //       matchingController.getUserList();
//       //     },
//       //     ),
//       // ),
//       body: GetBuilder<MatchingController>(builder: (_) { return UserCard(user: matchingController.userDataList[0]); }),
//     );
//   }
// }