import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:strife/Screens/Notification/controllers/notification_controller.dart';
import 'package:strife/Screens/Notification/view_sender_user_screen.dart';
import 'package:strife/Screens/Post/controllers/post_controller.dart';
import 'package:strife/Screens/Post/create_post_screen.dart';
import 'package:strife/Screens/Post/modify_post_Screen.dart';
import 'package:strife/constants.dart';

class ViewPostScreen extends StatelessWidget {
  const ViewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostController());
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Post"),
        backgroundColor: appBarPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: () { 
              postController.getPost();
            }
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () { 
              Get.to(() => const CreatePostScreen());
            }
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          child: GetBuilder<PostController>(builder: (_) {
            return Column(
              children: [
                const SizedBox(height: 10,),
                postController.postList.isNotEmpty
                ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postController.postList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        postController.toModifyScreen(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(postController.postList[index].url),
                                  ),
                                  const SizedBox(width: 8.0,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          postController.postList[index].userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(postController.postList[index].date.millisecondsSinceEpoch + (1000*60*60*8)))),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8.0,),
                              Text(postController.postList[index].content),
                            ],
                          ),
                        ),
                      ),
                    );
                    // return Card(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 8),
                    //     child: ListTile(
                    //       leading: GestureDetector(
                    //         onTap: () {
      
                    //         },
                    //         child: CircleAvatar(
                    //           radius: 28,
                    //           backgroundImage: NetworkImage(postController.postList[index].url),
                    //         ),
                    //       ),
                    //       title: Text(postController.postList[index].userName),
                    //       subtitle: Text(postController.postList[index].title),
                    //     ),
                    //   ),
                    // );
                  },
                )
                : Center(child: Text("There is no Post", style: Theme.of(context).textTheme.bodyLarge)),
              ],
            );
          }),
        ),
      ),
    );
  }
}