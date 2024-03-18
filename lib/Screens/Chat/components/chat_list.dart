import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Chat/components/chat_left_items.dart';
import 'package:strife/Screens/Chat/components/chat_right_items.dart';
import 'package:strife/Screens/Chat/controllers/chat_controller.dart';
import 'package:strife/Screens/Chat/controllers/message_controller.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    // final chatController = Get.put(ChatController());
    final messageController = Get.put(MessageController());
    // return Container(
    //   height: 500,
    //   width: 250,
    //   color: Colors.amber,
    //   child: Text("HELLO"),
    // );

    // return GetBuilder<ChatController>(builder: (_) {
    //   return Container(
    //     color: Colors.amber,
    //     padding: EdgeInsets.only(bottom: 100),
    //     child: CustomScrollView(
    //       reverse: true,
    //       // controller: chatController.messageController,
    //       controller: messageController.scrollController,
    //       slivers: [
    //         SliverPadding(
    //           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    //           sliver: SliverList(
    //             delegate: SliverChildBuilderDelegate((context, index) {
    //               var item = messageController.messageContent1[index];
    //               if (messageController.currentUserUid == item.uid) {
    //                 return ChatRightItems(item);
    //               }
    //               // else {
    //               //   return ChatRightItems(item);
    //               // }
    //             },
    //             childCount: messageController.messageContent1.length
    //             )
    //           )
    //         ), 
    //       ],
    //     ),
    //   );
    // });

    return Obx(() => Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Chat_Background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(bottom: 100),
      child: CustomScrollView(
        reverse: true,
        // controller: chatController.messageController,
        controller: messageController.scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                var item = messageController.messageContent1[index];
                if (messageController.currentUserUid == item.uid) {
                  return ChatRightItems(item);
                }
                else {
                  return ChatLeftItems(item);
                }
              },
              childCount: messageController.messageContent1.length
              )
            )
          ), 
        ],
      ),
    ));

    // return Obx(() => Container(
    //   color: Colors.amber,
    //   padding: EdgeInsets.only(bottom: 100),
    //   child: CustomScrollView(
    //     reverse: true,
    //     controller: chatController.messageController,
    //     slivers: [
    //       SliverPadding(
    //         padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    //         sliver: SliverList(
    //           delegate: SliverChildBuilderDelegate((context, index) {
    //             var item = chatController.messageContent[index];
    //             if (chatController.currentUserUid == item.uid) {
    //               return ChatRightItems(item);
    //             }
    //             else {
    //               return ChatRightItems(item);
    //             }
    //           },
    //           childCount: chatController.messageContent.length
    //           )
    //         )
    //       ), 
    //     ],
    //   ),
    // )
    // );
  }
}