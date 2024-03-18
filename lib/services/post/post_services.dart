import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:strife/models/post.dart';

class PostService extends GetxController {
  static PostService get post => Get.find();

  CollectionReference postCollection = FirebaseFirestore.instance.collection("post");
  CollectionReference user = FirebaseFirestore.instance.collection("user");

  Future<String> getCurrentUID() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> createPost(String content, String userID) async {
    await postCollection.add({
      "content" : content,
      "userID" : userID,
      "time" : Timestamp.now(),
    }).then((value) => print("Post ${value.id} is created"))
    .catchError((error) => print("Failed to create post: $error"));
  }

  Future<List<Post>> getSelfPostList(String currentUserUid) async {
    print("In get self Post");
    List<Post> postList = [];
    String currentUserName = '';
    String url = '';
    
    final QuerySnapshot postQuerySnapshot = await postCollection
    .where("userID", isEqualTo: currentUserUid)
    .orderBy("time", descending: true)
    .get();

    if (postQuerySnapshot.docs.isNotEmpty) {
      await user.doc(currentUserUid).get().then((value) { 
        currentUserName = value.get('name');
        url = value.get('url');
      });

      postList = postQuerySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        return Post(
          content: data['content'],
          date: data['time'],
          userName: currentUserName,
          url: url,
          postID: doc.id
        );
      }).toList();

    }

    return postList;
  }

  Future<void> updateSelfPostList(String postID, String content) async {
    await postCollection.doc(postID).update({
      "content": content,
      "time" : Timestamp.now(),
    }).then((value) => print("Post $postID content and time is updated"))
    .catchError((error) => print("Failed to update post content and time: $error"));
  }

  // Future<List<Post>> getAllPostList() async {
  //   print("In get self Post");
  //   List<Post> postList = [];
  //   String currentUserName = '';
  //   String url = '';
    
  //   final QuerySnapshot postQuerySnapshot = await postCollection
  //   .orderBy("time", descending: true)
  //   .get();

  //   if (postQuerySnapshot.docs.isNotEmpty) {
      

  //     await user.doc().get().then((value) { 
  //       currentUserName = value.get('name');
  //       url = value.get('url');
  //     });

  //     postList = postQuerySnapshot.docs.map((doc) {
  //       final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
  //       return Post(
  //         content: data['content'],
  //         date: data['time'],
  //         userName: currentUserName,
  //         url: url,
  //       );
  //     }).toList();

  //   }

  //   return postList;
  // }

  Future<List<Post>> getAllPostList() async {
    List<Post> postList = [];
    
    final QuerySnapshot postQuerySnapshot = await postCollection
      .orderBy("time", descending: true)
      .get();

    if (postQuerySnapshot.docs.isNotEmpty) {
      postList = await Future.wait(postQuerySnapshot.docs.map((postDoc) async {
        final Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
        final String userID = postData['userID'];
        String currentUserName = '';
        String url = '';

        final DocumentSnapshot userSnapshot = await user.doc(userID).get();
        if (userSnapshot.exists) {
          currentUserName = userSnapshot.get('name');
          url = userSnapshot.get('url');
        }

        return Post(
          content: postData['content'],
          date: postData['time'],
          userName: currentUserName,
          url: url,
          postID: postDoc.id
        );
      }));
    }

    return postList;
  }
}