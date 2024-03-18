import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Notification/controllers/notification_controller.dart';
import 'package:strife/Screens/Notification/view_sender_user_screen.dart';
import 'package:strife/constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Friend"),
        backgroundColor: appBarPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: () async { 
              await notificationController.readSenderUserDataList();
              print("notificationController.senderUserDataList.length");
              print(notificationController.senderUserDataList.length);
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: GetBuilder<NotificationController>(builder: (_) {
          return Column(
            children: [
              const SizedBox(height: 10,),
              Center(child: Text("Friend Request", style: Theme.of(context).textTheme.headlineSmall)),
              SizedBox(height: 15,),
              notificationController.senderUserDataList.isNotEmpty
              ? ListView.builder(
                shrinkWrap: true,
                itemCount: notificationController.senderUserDataList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            // print(notificationController.senderUserDataList[index].name);
                            // print(notificationController.senderUserDataList[index].age);
                            // print(notificationController.senderUserDataList[index].address);
                            // print(notificationController.senderUserDataList[index].email);
                            // print(notificationController.senderUserDataList[index].gender);
                            // print(notificationController.senderUserDataList[index].phone);
                            // print(notificationController.senderUserDataList[index].steamID);
                            // print(notificationController.senderUserDataList[index].url);
                            // print(notificationController.senderUserDataList[index].games![0].name);
                            print("index");
                            print(index);
                            Get.to(() => ViewSenderUserScreen(user: notificationController.senderUserDataList[index], userIndex: index));
                          },
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(notificationController.senderUserDataList[index].url),
                          ),
                        ),
                        title: Text(notificationController.senderUserDataList[index].name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => notificationController.setFriendRequestStatus(index, "accepted"),
                              style: ButtonStyle(
                                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                backgroundColor: MaterialStatePropertyAll(Colors.green.shade300),
                              ),
                              child: const Text("Accept"),
                            ),
                            const SizedBox(width: 5,),
                            TextButton(
                              onPressed: () => notificationController.setFriendRequestStatus(index, "decline"),
                              style: ButtonStyle(
                                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                backgroundColor: MaterialStatePropertyAll(Colors.red.shade300),
                              ),
                              child: const Text("Decline"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
              : Center(child: Text("There is no Friend Request", style: Theme.of(context).textTheme.bodyLarge)),
              // SizedBox(height: 25,),
              // Text("Decline", style: Theme.of(context).textTheme.headlineSmall),
              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: notificationController.receiverUserDataList.length,
              //   itemBuilder: (context, index) {
              //     return Card(
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 8),
              //         child: ListTile(
              //           leading: CircleAvatar(
              //             radius: 28,
              //             backgroundImage: NetworkImage(notificationController.receiverUserDataList[index].url),
              //           ),
              //           title: Text(notificationController.receiverUserDataList[index].name),
              //           trailing: const Icon(Icons.arrow_forward),
              //           onTap: () {
              //             print("GO");
              //           },
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          );
        }),
      ),
    );
  }
}