import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchingService extends GetxController {
  static MatchingService get matching => Get.find();

  CollectionReference user = FirebaseFirestore.instance.collection('user');
  CollectionReference notification = FirebaseFirestore.instance.collection("notification");
  CollectionReference chat = FirebaseFirestore.instance.collection("chat");

  Future<String> getCurrentUID() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> createRequest(String currentUserUid, String userUid) async {
    // only receiver will receive notification
    // other user is receiver, current user is sender
    final querySnapshot = await notification
      .where('sender', isEqualTo: currentUserUid)
      .where('receiver', isEqualTo: userUid)
      .get();

    // other user is sender, current user is receiver
    final reverseQuerySnapshot = await notification
      .where('sender', isEqualTo: userUid)
      .where('receiver', isEqualTo: currentUserUid)
      .get();

    // sender already send notification to current user
    // but current user click add button (sender) in matching screen
    if (reverseQuerySnapshot.docs.isNotEmpty) {

      // update status to accepted
      final friendRequestDoc = reverseQuerySnapshot.docs.first;
      await friendRequestDoc.reference.update({'status': 'accepted'})
      .then((value) => print("status is change to accepted"))
      .catchError((error) => print("Failed to change status to accepted: $error"));

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
        friends: data?["friend"] is Iterable ? List.from(data?["friend"]) : null,
      );

      MyUser otherUser;
      var otherUserDocsnapshot = await user.doc(userUid).get();
      Map<String,dynamic>?otherUserData = otherUserDocsnapshot.data() as Map<String, dynamic>?;
      otherUser = MyUser(
        uid: userUid,
        name: otherUserData?["name"],
        email: otherUserData?["email"],
        gender: otherUserData?["gender"],
        age: otherUserData?["age"],
        address: otherUserData?["address"],
        phone: otherUserData?["phone"],
        steamID: otherUserData?["steamID"],
        url: otherUserData?["url"],
        about: otherUserData?["about"],
        friends: otherUserData?["friend"] is Iterable ? List.from(otherUserData?["friend"]) : null,
      );

      print("Before chat add in matching");
      if (myuser.friends != null) {
        print("current user friend data is not null. Check it consist of $userUid or not");
        // check whether current user's friends contains sender ID or not
        // if it containe sender ID then nothing happen
        // if it does not contain sender ID then add the chat
        if (myuser.friends!.contains(userUid)) {
          print("Already add as friend, nothing happen");
        } else {
          print("Not add as friend, add it as friend now");
          await chat.add({
            "lastMessage": "",
            "lastTime": Timestamp.now(),
            "user1": myuser.uid,
            "userImg1": myuser.url,
            "userName1": myuser.name,
            "user2": otherUser.uid,
            "userImg2": otherUser.url,
            "userName2": otherUser.name,
          }).then((value) => print("chat is add, doc id is ${value.id}"))
          .catchError((error) => print("Failed to add chat: $error"));
        }
      }
      
      // add friend ID in both user
      updateUserFriend(currentUserUid, userUid);
      updateUserFriend(userUid, currentUserUid);

    } else if (querySnapshot.docs.isNotEmpty) {
      // current user is sender but click on the receiver add button again in matching screen
      // nothing will happen
    } else if (querySnapshot.docs.isEmpty){
      await notification.add({
        'sender': currentUserUid,
        'receiver': userUid,
        'status': 'pending',
      }).then((value) => print("Friend request is created"))
    .catchError((error) => print("Failed to create friend request: $error"));
    }
  }

  Future<void> updateUserFriend(String userUid1, String userUid2) async {
    DocumentReference userData = user.doc(userUid1);
    await userData.update({
      'friend': FieldValue.arrayUnion([userUid2]),
    });
  }

  Future<List<MyUser>> getUserDataList(String uid) async {
    List<MyUser> userDataList = [];

    final QuerySnapshot querySnapshot = await user.get();
    final DocumentSnapshot<Object?> documentSnapshot = await user.doc(uid).get();
    List<String>? friendList;
    if (documentSnapshot.get('friend') != null) {
      friendList =  documentSnapshot.get('friend') is Iterable ? List.from(documentSnapshot.get('friend')) : null;
    }

    for (var document in querySnapshot.docs) {
      if (document.id == uid ) continue;        // Skip user's own document
      if (friendList != null) { 
        if (friendList.contains(document.id)) { // Skip user's friends
          continue;
        }
      }
      final userData = MyUser(
        uid: document.id,
        name: document["name"],
        email: document["email"],
        gender: document["gender"],
        age: document["age"],
        address: document["address"],
        phone: document["phone"],
        steamID: document["steamID"],
        url: document["url"],
        about: document["about"],
      );

      final gamesCollection = document.reference.collection("games");
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

      userData.games = gamesData;

      userDataList.add(userData);
    }

    return userDataList;
  }

  Future<List<MyUser>> getFilterUserDataList(String uid, String gender, int minAge, int maxAge, String game) async {
    String orderGame = "rtime_last_played";
    bool checkGameIsSame = false;
    List<MyUser> filterUserDataList = [];

    final QuerySnapshot querySnapShot = await user
      .where("gender", isEqualTo: gender)
      .where("age", isGreaterThanOrEqualTo: minAge, isLessThanOrEqualTo: maxAge)
      .get();

    if (game == "Recent") {
      orderGame = "rtime_last_played";
      checkGameIsSame = false;
    }
    else if(game == "Longest") {
      orderGame = "playtime_forever";
      checkGameIsSame = false;
    }
    else if(game == "Same") {
      checkGameIsSame = true;
    }

    if (!checkGameIsSame) {
      for (var document in querySnapShot.docs) {
        if (document.id == uid) continue; // Skip user's own document

        final userData = MyUser(
          uid: uid,
          name: document["name"],
          email: document["email"],
          gender: document["gender"],
          age: document["age"],
          address: document["address"],
          phone: document["phone"],
          steamID: document["steamID"],
          url: document["url"],
          about: document["about"],
        );

        final gamesCollection = document.reference.collection("games");
        final gamesSnapshot = await gamesCollection.orderBy(orderGame, descending: true).get();

        final gamesData = gamesSnapshot.docs.map((gameDoc) {
          return Games(
            appid: int.parse(gameDoc.id),
            imgIconUrl: gameDoc["img_icon_url"],
            name: gameDoc["name"],
            playtimeForever: gameDoc["playtime_forever"],
            rtimeLastPlayed: gameDoc["rtime_last_played"],
          );
        }).toList();

        userData.games = gamesData;

        filterUserDataList.add(userData);
      }
    } else {
      var ownQuerySnapShot = await user.doc(uid).collection("games").get();
      List<Games>userOwnedGames = ownQuerySnapShot.docs.map((doc) {
        return Games(
          appid: doc.data()['appid'],
          name: doc.data()['name'],
          playtimeForever: doc.data()['playtime_forever'],
          imgIconUrl: doc.data()['img_icon_url'],
          rtimeLastPlayed: doc.data()['rtime_last_played'],
        );
      }).toList();

      final myGames = await getMyGames(uid);

      for (var document in querySnapShot.docs) {
        if (document.id == uid) continue; // Skip user's own document

        final userData = MyUser(
          uid: uid,
          name: document["name"],
          email: document["email"],
          gender: document["gender"],
          age: document["age"],
          address: document["address"],
          phone: document["phone"],
          steamID: document["steamID"],
          url: document["url"],
          about: document["about"],
        );

        final gamesCollection = document.reference.collection("games");
        final gamesSnapshot = await gamesCollection.orderBy(orderGame, descending: true).get();

        final gamesData = gamesSnapshot.docs.map((gameDoc) {
          return Games(
            appid: int.parse(gameDoc.id),
            imgIconUrl: gameDoc["img_icon_url"],
            name: gameDoc["name"],
            playtimeForever: gameDoc["playtime_forever"],
            rtimeLastPlayed: gameDoc["rtime_last_played"],
          );
        }).toList();

        var sharedGames = gamesData.where((game) => myGames.contains(game.appid));

        if (sharedGames.isNotEmpty) {
          userData.games = gamesData;
          userData.sameGames = sharedGames.toList();
          filterUserDataList.add(userData);
        }
      }
    }

    return filterUserDataList;
  }

  Future<List<int>> getMyGames(String uid) async {
    final myGamesCollection = user.doc(uid).collection("games");
    final myGamesSnapshot = await myGamesCollection.get();

    final myGames = myGamesSnapshot.docs.map<int>((gameDoc) => int.parse(gameDoc.id)).toList();
    return myGames;
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

    return userOwnedGames;
  }
}