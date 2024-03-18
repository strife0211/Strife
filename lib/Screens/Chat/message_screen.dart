import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Chat/components/chat_list.dart';
import 'package:strife/Screens/Chat/controllers/chat_controller.dart';
import 'package:strife/Screens/Chat/controllers/message_controller.dart';
import 'package:strife/constants.dart';
import 'package:strife/models/message.dart';

class MessageScreen extends StatelessWidget {
  final Message message;

  const MessageScreen({
    Key? key,
    required this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    final messageController = Get.put(MessageController());
    return Scaffold(
      appBar: AppBar(
        title: Container(
          // padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
                child: InkWell(
                  onTap: () {
                    chatController.viewFriendScreen(message.userUid);
                  },
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: CircleAvatar(
                      // radius: 28,
                      backgroundImage: NetworkImage(message.userImg),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 25,),
              Container(
                // width: 180,
                child: Text(
                  message.userName,
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: const TextStyle(
                    // fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: appBarPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Stack(
            children: [
              const ChatList(),
              Positioned(
                bottom: 0,
                height: 75,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 300,
                        height: 50,
                        child: TextField(
                          // keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          autofocus: false,
                          controller: messageController.textController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade300,
                            hintText: "Send messages..."
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 5),
                        width: 65,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () => messageController.sendMessage(),
                          child: const Text("Send"),
                        ),
                      )
                    ],
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}