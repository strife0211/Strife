import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ProfileService extends GetxController {
  static ProfileService get profile => Get.find();
  
  CollectionReference user = FirebaseFirestore.instance.collection('user');
  CollectionReference chat = FirebaseFirestore.instance.collection("chat");

  Future<String> getCurrentUID() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> createUserOwnedGames(String uid, SteamOwnedGames ownedGames) async {
    
    ownedGames.response!.games!.forEach((element) async {
      String appid = element.appid.toString();
      // print("appid");
      // print(appid);
      await user.doc(uid).collection("games").doc(appid).set({
        'appid' : element.appid,
        'name' : element.name,
        'playtime_forever' : element.playtimeForever,
        'img_icon_url' : element.imgIconUrl,
        'rtime_last_played' : element.rtimeLastPlayed,
    }).then((value) => print("Games ${appid} - ${element.name} are add"))
    .catchError((error) => print("Failed to add Games: $error"));
    });
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


  Future<MyUser> getUserData(String uid) async {
    var myuser;
    var docsnapshot = await user.doc(uid).get();
    if(docsnapshot.exists) {
      Map<String,dynamic>?data = docsnapshot.data() as Map<String, dynamic>?;
      myuser = MyUser(
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
    print("MyUser: " + myuser.name);

    return myuser;
  }

  Future<void>updateUser(String uid, String name, String gender, int age, String address, String phone, String about, File? selectedFile) async {
    String url = "";
    DocumentReference userinfo = user.doc(uid);

    if (selectedFile!=null) {
      url = await uploadImageToFirebase(selectedFile);
    }
    if(url!="") {
      return userinfo.update({
        'name' : name,
        'gender': gender,
        'age': age,
        'address': address,
        'phone': phone,
        'url' : url,
        'about' : about,
      }).then((value) async{
        await updateChatData(uid, name, url);
        Get.back();
        print("User Updated!");
      }).catchError((error)=>print("Fail!"));
    }
    else {
      return userinfo.update({
        'name' : name,
        'gender': gender,
        'age': age,
        'address': address,
        'phone': phone,
        'about' : about,
      }).then((value) async{
        await updateChatData(uid, name, url);
        Get.back();
        print("User Updated!");
      }).catchError((error)=>print("Fail!"));
    }
  }

  Future<void> updateChatData(String uid, String name, String url) async {
    QuerySnapshot user1 = await chat.where('user1', isEqualTo: uid).get();
    QuerySnapshot user2 = await chat.where('user2', isEqualTo: uid).get();
    print("updateChatData");

    if (url == "") {
      // Update documents for user1
      for (QueryDocumentSnapshot doc in user1.docs) {
        await chat.doc(doc.id).update({
          'userName1': name,
        });
      }

      // Update documents for user2
      for (QueryDocumentSnapshot doc in user2.docs) {
        await chat.doc(doc.id).update({
          'userName2': name,
        });
      }
    }
    else{
      print("URL" + url);
      // Update documents for user1
      for (QueryDocumentSnapshot doc in user1.docs) {
        await chat.doc(doc.id).update({
          'userName1': name,
          'userImg1': url,
        });
      }

      // Update documents for user2
      for (QueryDocumentSnapshot doc in user2.docs) {
        await chat.doc(doc.id).update({
          'userName2': name,
          'userImg2': url,
        });
      }
    }
    
  }

  Future<String> uploadImageToFirebase (File image) async {
    final fileName = basename(image.path);
    final destination = 'UserProfile/$fileName';
    UploadTask? task = await uploadFile(destination, image);
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = snapshot.ref.getDownloadURL();
    return urlDownload;
  }

  static Future<UploadTask?> uploadFile(String destination, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}