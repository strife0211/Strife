import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:strife/Screens/Post/modify_post_Screen.dart';
import 'package:strife/models/post.dart';
import 'package:strife/services/post/post_services.dart';
import 'package:intl/date_symbol_data_local.dart';

class PostController extends GetxController {
  static PostController get post => Get.find();

  late String currentUserUid;
  late List<Post> postList;
  late List<Post> allPostList;

  late final content = TextEditingController();
  late TextEditingController modifyContent = TextEditingController();

  Future<void> getCurrentUserUID() async {
    currentUserUid = await PostService.post.getCurrentUID();
    print("currentUserUid: " + currentUserUid);
  }

  Future<void> createPost(String content) async {
    await PostService.post.createPost(content, currentUserUid);
    await getPost();
    Get.back();
  }

  Future<void> modifyPost(String postID, String content) async {
    await PostService.post.updateSelfPostList(postID, content);
    await getPost();
    Get.back();
  }

  Future<void> getPost() async {
    print("In get post");
    postList = await PostService.post.getSelfPostList(currentUserUid);
    update();
    print("after get post");
  }

  Future<void> getAllPost() async {
    print("In get post");
    allPostList = await PostService.post.getAllPostList();
    update();
    print("after get post");
  }

  void toModifyScreen(int index) {
    modifyContent = TextEditingController(text: postList[index].content);
    Get.to(() => ModifyPostScreen(post: postList[index]));
  }
}