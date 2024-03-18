import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';

class NotificationService extends GetxController {
  static NotificationService get notification => Get.find();

  CollectionReference user = FirebaseFirestore.instance.collection('user');
  CollectionReference notificationCollection = FirebaseFirestore.instance.collection("notification");
  CollectionReference chat = FirebaseFirestore.instance.collection("chat");

  Future<String> getCurrentUID() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> setFriendRequestStatus(String currentUserUid, MyUser senderUser, String status) async {
    // current user is receriver and he receive sender's friend request
    final QuerySnapshot notificationQuerySnapshot = await notificationCollection
    .where("receiver", isEqualTo: currentUserUid)
    .where("sender", isEqualTo: senderUser.uid)
    .get();

    MyUser myuser;
    var docsnapshot = await user.doc(currentUserUid).get();
    Map<String,dynamic>?data = docsnapshot.data() as Map<String, dynamic>?;
    myuser = MyUser(
      uid: currentUserUid,
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

    if (notificationQuerySnapshot.docs.isNotEmpty) {
      // update status
      await notificationQuerySnapshot.docs.first.reference.update({'status': status})
      .then((value) => print("status is change to $status"))
      .catchError((error) => print("Failed to change status: $error"));

      print("Before accepted");

      // if status is accepted then add chat
      // else nothing happen
      if (status == "accepted") {
        print("inside accepted");
        await chat.add({
          "lastMessage": "",
          "lastTime": Timestamp.now(),
          "user1": myuser.uid,
          "userImg1": myuser.url,
          "userName1": myuser.name,
          "user2": senderUser.uid,
          "userImg2": senderUser.url,
          "userName2": senderUser.name,
        }).then((value) async {
          print("chat is add, doc id is ${value.id}");

          // await chat.doc(value.id).collection("user").doc().set({
          //   "id" : myuser.uid,
          //   "userImg" : myuser.url,
          //   "userName" : myuser.name,
          // }).then((value) => print("current user is add"))
          // .catchError((error) => print("Failed to add current user: $error"));

          // await chat.doc(value.id).collection("user").doc().set({
          //   "id" : senderUser.uid,
          //   "userImg" : senderUser.url,
          //   "userName" : senderUser.name,
          // }).then((value) => print("user is add"))
          // .catchError((error) => print("Failed to add user: $error"));

        })
        .catchError((error) => print("Failed to add chat: $error"));

      }

      // add friend ID in both user
      updateUserFriend(currentUserUid, senderUser.uid);
      updateUserFriend(senderUser.uid, currentUserUid);
    }
  }

  Future<void> updateUserFriend(String userUid1, String userUid2) async {
    DocumentReference userData = user.doc(userUid1);
    await userData.update({
      'friend': FieldValue.arrayUnion([userUid2]),
    });
  }

  Future<List<MyUser>> getSenderUserDataList(String currentUserUid) async {
    List<MyUser> senderUserDataList = [];
    
    final QuerySnapshot notificationQuerySnapshot = await notificationCollection
    .where("receiver", isEqualTo: currentUserUid)
    .where("status", isEqualTo: "pending")
    .get();

    if (notificationQuerySnapshot.docs.isNotEmpty) {
      
      final List senderUids = notificationQuerySnapshot.docs.map((doc) => doc['sender']).toList();

      for (final senderUid in senderUids) {
        final DocumentSnapshot userSnapshot = await user.doc(senderUid).get();

        if (userSnapshot.exists) {
          final senderUserData = MyUser(
            uid: userSnapshot.id,
            name: userSnapshot['name'],
            email: userSnapshot['email'],
            gender: userSnapshot['gender'],
            age: userSnapshot['age'],
            address: userSnapshot['address'],
            phone: userSnapshot['phone'],
            steamID: userSnapshot['steamID'],
            url: userSnapshot['url'],
            about: userSnapshot['about'],
          );

          final gamesCollection = userSnapshot.reference.collection("games");
          final gamesSnapshot = await gamesCollection.orderBy("rtime_last_played", descending: true).get();

          final gamesData = gamesSnapshot.docs.map((gameDoc) {
            return Games(
              appid: int.parse(gameDoc.id),
              imgIconUrl: gameDoc["img_icon_url"],
              name: gameDoc["name"],
              playtimeForever: gameDoc["playtime_forever"],
              rtimeLastPlayed: gameDoc["rtime_last_played"],
            );
          }).toList();

          print("gamesData");
          print(gamesData);

          senderUserData.games = gamesData;

          senderUserDataList.add(senderUserData);
          print("senderUserData.name in services");
          print(senderUserData.name);
        }
      }
    }

    return senderUserDataList;

  }

  Future<List<MyUser>> getReceiverUserDataList(String currentUserUid) async {
    List<MyUser> receiverUserDataList = [];
    
    final QuerySnapshot notificationQuerySnapshot = await notificationCollection
    .where("sender", isEqualTo: currentUserUid)
    .where("status", isEqualTo: "pending")
    .get();

    if (notificationQuerySnapshot.docs.isNotEmpty) {
      
      final List receiverUids = notificationQuerySnapshot.docs.map((doc) => doc['receiver']).toList();

      for (final receiverUid in receiverUids) {
        final DocumentSnapshot userSnapshot = await user.doc(receiverUid).get();

        if (userSnapshot.exists) {
          final receiverUserData = MyUser(
            uid: userSnapshot.id,
            name: userSnapshot['name'],
            email: userSnapshot['email'],
            gender: userSnapshot['gender'],
            age: userSnapshot['age'],
            address: userSnapshot['address'],
            phone: userSnapshot['phone'],
            steamID: userSnapshot['steamID'],
            url: userSnapshot['url'],
            about: userSnapshot['about'],
          );
          receiverUserDataList.add(receiverUserData);
          print("receiverUserData.name in services");
          print(receiverUserData.name);
        }
      }
    }

    return receiverUserDataList;

  }

  Future<List<Games>> getUserOwnedGames(String uid) async {
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