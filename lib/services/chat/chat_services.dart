import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Chat/controllers/chat_controller.dart';
import 'package:strife/models/message.dart';
import 'package:strife/models/message_content.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';
import 'package:async/async.dart';

class ChatService extends GetxController {
  static ChatService get chat => Get.find();

  CollectionReference user = FirebaseFirestore.instance.collection("user");
  CollectionReference chatCollection = FirebaseFirestore.instance.collection("chat");
  List<MessageContent> list1 = [];
  late MessageContent model;

  Future<String> getCurrentUID() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }
  
  Future<List<Message>> getMessageData(currentUserUid) async {
    List<Message> message = [];

    var chatQuerySnapshot1 = await chatCollection.where("user1", isEqualTo: currentUserUid).get();
    var chatQuerySnapshot2 = await chatCollection.where("user2", isEqualTo: currentUserUid).get();

    if (chatQuerySnapshot1.docs.isNotEmpty) {
      var chatting = chatQuerySnapshot1.docs.map((doc) {
        print("doc.id");
        print(doc.id);
        return Message(
          documentID: doc.id,
          // lastMessage: doc['lastMessage'],
          // lastTime: doc['lastTime'],
          currentUserUid: doc['user1'],
          currentUserName: doc['userName1'],
          currentUserImg: doc['userImg1'],
          userUid: doc['user2'],
          userName: doc['userName2'],
          userImg: doc['userImg2'],
        );
      }).toList();
    
      chatting.forEach((element) {
        message.add(element);
      });
    }

    if (chatQuerySnapshot2.docs.isNotEmpty) {
      var chatting = chatQuerySnapshot2.docs.map((doc) {
        return Message(
          documentID: doc.id,
          // lastMessage: doc['lastMessage'],
          // lastTime: doc['lastTime'],
          currentUserUid: doc['user2'],
          currentUserName: doc['userName2'],
          currentUserImg: doc['userImg2'],
          userUid: doc['user1'],
          userName: doc['userName1'],
          userImg: doc['userImg1'],
        );
      }).toList();
    
      chatting.forEach((element) {
        message.add(element);
      });
    }
    
    return message;
  }

//   Stream<List<Message>> getRealTimeMessageData(String currentUserUid) {
//   Stream<QuerySnapshot<Map<String, dynamic>>> chatQuerySnapshot1 =
//       chatCollection.where("user1", isEqualTo: currentUserUid).snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;

//   Stream<QuerySnapshot<Map<String, dynamic>>> chatQuerySnapshot2 =
//       chatCollection.where("user2", isEqualTo: currentUserUid).snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;

//   return StreamZip([chatQuerySnapshot1, chatQuerySnapshot2]).map((results) {
//     List<Message> messages = [];

//     final snapshot1 = results[0];
//     final snapshot2 = results[1];

//     messages.addAll(snapshot1.docs.map((doc) {
//       return Message(
//         documentID: doc.id,
//         lastMessage: doc['lastMessage'],
//         lastTime: doc['lastTime'],
//         currentUserUid: doc['user1'],
//         currentUserName: doc['userName1'],
//         currentUserImg: doc['userImg1'],
//         userUid: doc['user2'],
//         userName: doc['userName2'],
//         userImg: doc['userImg2'],
//       );
//     }));

//     messages.addAll(snapshot2.docs.map((doc) {
//       return Message(
//         documentID: doc.id,
//         lastMessage: doc['lastMessage'],
//         lastTime: doc['lastTime'],
//         currentUserUid: doc['user2'],
//         currentUserName: doc['userName2'],
//         currentUserImg: doc['userImg2'],
//         userUid: doc['user1'],
//         userName: doc['userName1'],
//         userImg: doc['userImg1'],
//       );
//     }));

//     return messages;
//   });
// }

  Future<void> sendMessages(String documentID, String currentUserUid, String sendContent) async {
    await chatCollection.doc(documentID).collection("messageList").add({
      "uid": currentUserUid,
      "content": sendContent,
      "addtime": Timestamp.now(),
    }).then((value) => print("Message list is added"))
    .catchError((error) => print("Failed to add message list: $error"));
  
    await chatCollection.doc(documentID).update({
      "lastMessage": sendContent,
      "lastTime": Timestamp.now(),
    }).then((value) => print("Chat Collection last message and time is updated"))
    .catchError((error) => print("Failed to update last message and time: $error"));
  }

  // Future<List<MessageContent>> readMessages(String documentID) async {
  //   var messages = await chatCollection.doc(documentID).collection("messageList")
  //   .orderBy("addtime", descending: true)
  //   .get();

  //   var message = messages.docs.map((doc) {
  //     // print("doc.id");
  //     // print(doc.id);
  //     return MessageContent(
  //       uid: doc['uid'],
  //       content: doc['content'],
  //       addtime: doc['addtime'],
  //     );
  //   }).toList();

  //   print("message");
  //   // print(message[0].content);

  //   return message;
  // }

  // Future<void> updateMessages(String documentID) async {
  //   late MessageContent model;
  //   List<MessageContent> list = [];
    
  //   var messages = chatCollection.doc(documentID).collection("messageList")
  //   .orderBy("addtime", descending: false);
    
  //   print("UpdateMessages in ChatService");

  //   void listener = messages.snapshots().listen((event) {
  //     print("event");
  //     print(event.docs);
  //     // ChatController.chat.messageContent.clear();

  //     for(var change in event.docChanges) {
  //       switch (change.type) {
  //         case DocumentChangeType.added:
  //           if(change.doc.data()!=null) {
  //             model = MessageContent(
  //               uid: change.doc.data()!['uid'],
  //               content: change.doc.data()!['content'],
  //               addtime: change.doc.data()!['addtime'],
  //             );
  //           }
  //           break;

  //         case DocumentChangeType.modified:
  //           break;

  //         case DocumentChangeType.removed:
  //           break;
  //       }
  //       // MessageContent model = MessageContent(
  //       //   uid: item.get('uid'),
  //       //   content: item.get('content'),
  //       //   addtime: item.get('addtime'),
  //       // );

  //       // list.add(model);

  //       // model = MessageContent(
  //       //   uid: change.doc.data()!['uid'],
  //       //   content: change.doc.data()!['content'],
  //       //   addtime: change.doc.data()!['addtime'],
  //       // );

  //     }

  //     // print("model");
  //     // print(model.content);

  //     // ChatController.chat.messageContent.assignAll(list);
  //     ChatController.chat.updateMessageInController(model);

  //     // for(var change in event.docChanges) {
  //     //   print("change");
  //     //   print(change);
  //     //   switch (change.type) {
  //     //     case DocumentChangeType.added:
  //     //       if(change.doc.data()!=null) {
  //     //         print("change.doc.data()!['uid']");
  //     //         print(change.doc.data()!['uid']);
  //     //         print("change.doc.data()!['content']");
  //     //         print(change.doc.data()!['content']);
  //     //         print("change.doc.data()!['addtime']");
  //     //         print(change.doc.data()!['addtime']);
  //     //         MessageContent messageContents = MessageContent(
  //     //           uid: change.doc.data()!['uid'],
  //     //           content: change.doc.data()!['content'],
  //     //           addtime: change.doc.data()!['addtime']
  //     //         );
  //     //         ChatController.chat.messageContent.insert(0, messageContents);
  //     //       }
  //     //       break;

  //     //     case DocumentChangeType.modified:
  //     //       break;

  //     //     case DocumentChangeType.removed:
  //     //       break;
  //     //   }
  //     // }
  //   },
  //     onError: (error) => print("Listen failed: $error"),
  //   );
  // }

  updateMessages(String documentID) {
    
    var messages = chatCollection.doc(documentID).collection("messageList")
    .orderBy("addtime", descending: false);
    
    print("UpdateMessages in ChatService");

    return messages.snapshots().listen((event) {
      list1.clear();

      for(var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if(change.doc.data()!=null) {
              model = MessageContent(
                uid: change.doc.data()!['uid'],
                content: change.doc.data()!['content'],
                addtime: change.doc.data()!['addtime'],
              );
            }
            break;

          case DocumentChangeType.modified:
            break;

          case DocumentChangeType.removed:
            break;
        }
      }
      list1.add(model);
    },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  Future<MyUser> getFriendData(String uid) async {

    final DocumentSnapshot docsnapshot = await user.doc(uid).get();
    var querysnapshot = await user.doc(uid).collection("games").orderBy("rtime_last_played", descending: true).get();

    late MyUser friend;
    List<Games> userOwnedGames;

    if(docsnapshot.exists) {
      Map<String,dynamic>?data = docsnapshot.data() as Map<String, dynamic>?;
      friend = MyUser(
        uid: uid,
        name: data?["name"],
        email: data?["email"],
        gender: data?["gender"],
        age: data?["age"],
        address: data?["address"],
        phone: data?["phone"],
        steamID: data?["steamID"],
        url: data?["url"],
        about: data?["about"],
      );
    }

    userOwnedGames = querysnapshot.docs.map((doc) {
      return Games(
        appid: doc.data()['appid'],
        name: doc.data()['name'],
        playtimeForever: doc.data()['playtime_forever'],
        imgIconUrl: doc.data()['img_icon_url'],
        rtimeLastPlayed: doc.data()['rtime_last_played'],
      );
    }).toList();

    print("Friend: " + friend.name);

    friend.games = userOwnedGames;

    return friend;
  }

  Future<List<Games>> getFriendOwnedGames(String uid) async {
    List<Games> userOwnedGames;
    var querysnapshot = await user.doc(uid).collection("games").orderBy('name').get();
    
    userOwnedGames = querysnapshot.docs.map((doc) {
      return Games(
        appid: doc.data()['appid'],
        name: doc.data()['name'],
        playtimeForever: doc.data()['playtime_forever'],
        imgIconUrl: doc.data()['img_icon_url'],
        rtimeLastPlayed: doc.data()['rtime_last_played'],
      );
    }).toList();

    userOwnedGames.forEach((element) {
      print("userOwnedGames: element.name");
      print(element.name);
    });

    return userOwnedGames;
  }
}