import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Chat/controllers/chat_controller.dart';
import 'package:strife/Screens/Chat/message_screen.dart';
import 'package:strife/constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Chat"),
        backgroundColor: appBarPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: ()  { 
              chatController.getMessage();
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: GetBuilder<ChatController>(builder: (_) {
          return Column(
            children: [
              SizedBox(height: 15,),
              chatController.message.isNotEmpty
              ? ListView.builder(
                shrinkWrap: true,
                itemCount: chatController.message.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      ChatController.chat.toMessageScreen(index);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(chatController.message[index].userImg),
                          ),
                          title: Text(chatController.message[index].userName),
                          // subtitle: chatController.message[index].lastMessage == ""
                          // ? Text("No Message")
                          // : Text(chatController.message[index].lastMessage.toString()),
                          // trailing: chatController.message[index].lastTime == null
                          // ? Text("No Time")
                          // : Text(chatController.message[index].lastTime.toString()),
                        ),
                      ),
                    ),
                  );
                },
              )
              : Center(child: Text("You not add any friends yet", style: Theme.of(context).textTheme.bodyLarge)),
            ],
          );
        }),
      ),
    );
  }
}