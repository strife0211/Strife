import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strife/Screens/Post/controllers/post_controller.dart';
import 'package:strife/Screens/Post/create_post_screen.dart';
import 'package:strife/Screens/Post/view_post_screen.dart';
import 'package:strife/constants.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';
import 'package:strife/services/authentication/authentication_services.dart';
import 'package:strife/services/profile/profile_services.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  static ProfileController get profile => Get.find();
  static PostController get post => Get.find();
  
  late final name = TextEditingController(text: userData.name);
  late final age = TextEditingController(text: userData.age.toString());
  late final address = TextEditingController(text: userData.address);
  late final phone = TextEditingController(text: userData.phone);
  late final about = TextEditingController(text: userData.about);

  // late List<SteamOwnedGames> Games;

  final gender = ["Hidden", "Male", "Female"];
  late String selectedGender;

  late String currentUserUid;
  // late Rx<MyUser> userData = MyUser(uid: "uid", name: "name", email: "email", gender: "gender", age: "age", address: "address", phone: "phone", steamID: "steamID", url: "url").obs;
  late MyUser userData;
  File? selectedFile;
  // late Rx<Widget> childWidget = Image.network(userData.value.url).obs;
  late Widget childWidget = Image.network(userData.url);

  SteamOwnedGames? games;
  late List<Games> gamesList;
  var isDataLoadiang = false.obs;

  // getGames() async {
  //   try {
  //     isDataLoadiang(true);
  //     // http.Response response = await http.get(Uri.tryParse('https://api.steampowered.com/IPlayerService/GetOwnedGames/v1')!, headers: {
  //     //   'key': '9BEB75F51D398654FFA1D2EF3D6A05E7',
  //     //   'steamid': '76561198449879375',
  //     //   'include_appinfo': 'true'
  //     // });
  //     http.Response response = await http.get(Uri.tryParse('https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=9BEB75F51D398654FFA1D2EF3D6A05E7&steamid=76561198449879375&include_appinfo=true&format=json')!, headers: {

  //     });
  //     print("Response");
  //     print(response.statusCode);

  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body);
  //       print("Result");
  //       print(result);

  //       games = SteamOwnedGames.fromJson(result);
  //       print("Games: ");
  //       print(games!.response!.gameCount);
  //       // Profile.profile.createUserOwnedGames(currentUserUid, games!);
  //     } else {
  //       print("Else");
  //     }
  //   } catch (e) {
  //     print("Error while getting data is $e");
  //   } finally {
  //     isDataLoadiang(false);
  //   }
  // }

  getGames() async {
    try {
      isDataLoadiang(true);

      gamesList = await ProfileService.profile.getUserOwnedGames(currentUserUid);

      // print("gameList length: ");
      // print(gamesList.length);

    } catch (e) {
      print("Error while getting data is $e");
    } finally {
      isDataLoadiang(false);
    }
  }

  createGames(String steamID) async {
    try {
      http.Response response = await http.get(Uri.tryParse('https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=9BEB75F51D398654FFA1D2EF3D6A05E7&steamid=$steamID&include_appinfo=true&format=json')!);
      // print("Response");
      // print(response.statusCode);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        // print("Result");
        // print(result);

        games = SteamOwnedGames.fromJson(result);
        // print("Games: ");
        // print(games!.response!.gameCount);
        ProfileService.profile.createUserOwnedGames(currentUserUid, games!);
      } else {
        print("Else");
      }
    } catch (e) {
      print("Error while getting data is $e");
    }
  }

  TimeOfDay minutesToTimeOfDay(int minutes) {
      Duration duration = Duration(minutes: minutes);
      List<String> parts = duration.toString().split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Future<List<SteamOwnedGames>> getGames() async {
  //   String getGameUrl = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=9BEB75F51D398654FFA1D2EF3D6A05E7&steamid=76561198449879375&include_appinfo=true&format=json";

  //   final response = await http.get(Uri.parse(getGameUrl));

  //   final body = json.decode(response.body);
  //   print(body);
    
    
  //   Games = body.map<SteamOwnedGames>(SteamOwnedGames.fromJson).toList();

  //   Games.fromJson(json);
  // }

  void setSelected(String value){
    selectedGender = value;
    update();
    print("selectedGender: " + selectedGender);
  }

  // showImage () {
  //   if (selectedFile==null) {
  //     return Image.network(userData.url).obs;
  //   }
  //   else {
  //     // ImageProvider x = FileImage(selectedFile!);
  //     // return x;
  //     return Image.file(selectedFile!).obs;
  //   }
  // }

  // showImage () {
  //   if (selectedFile==null) {
  //     childWidget.value = Image.network(userData.value.url);
  //     print(childWidget);
  //   }
  //   else {
  //     // ImageProvider x = FileImage(selectedFile!);
  //     // return x;
  //     childWidget.value = Image.file(selectedFile!);
  //     print(childWidget);

  //   }
  // }

  showImage () {
    if (selectedFile==null) {
      // childWidget = Image.network(userData.value.url);
      childWidget = Image.network(userData.url);
      print(childWidget);
    }
    else {
      // ImageProvider x = FileImage(selectedFile!);
      // return x;
      childWidget = Image.file(selectedFile!);
      print(childWidget);
    }
    update();
  }

  // showImage () {
  //   if (selectedFile==null) {
  //     return true;
  //   }
  //   else {
  //     return false;
  //   }
  // }

  getImage (ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final cropped = (
        await ImageCropper().cropImage(
          sourcePath: image.path
          ,aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1)
          ,compressQuality:100,
          cropStyle: CropStyle.circle,
          maxHeight: 700,
          maxWidth:700,
          compressFormat:ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: appBarPrimaryColor,
              toolbarTitle:"Profile Image Cropper",
              backgroundColor:Colors.white,
            )
          ]
        )
      );
      print("Before selectedFile");
      selectedFile = File(cropped!.path);
      showImage();
      print("After selectedFile");
      print(childWidget);
    }
    // else {
    //   selectedFile = File();
    // }
  }

  Future<void> updateUser(String name, String gender, int age, String address, String phone, String about) async {
    await ProfileService.profile.updateUser(currentUserUid, name, gender, age, address, phone, about, selectedFile);
    readData();
  }

  Future<void> readData() async {
    currentUserUid = await ProfileService.profile.getCurrentUID();
    print("currentUserUid: " + currentUserUid);
    // userData.value = await Profile.profile.getUserData(currentUserUid);
    userData = await ProfileService.profile.getUserData(currentUserUid);
    selectedGender = userData.gender;
    update();
    print("selectedGender: " + selectedGender);
    print("userData: ");
    // print(userData.value.name);
    print(userData.name);
  }

  Future<void> goToViewPostScreen() async {
    print("Before post");
    await PostController.post.getCurrentUserUID();
    await PostController.post.getPost();
    print("After post");
    Get.to(() => const ViewPostScreen());
    print("After post2");
  }

  void signOut() {
    AuthenticationService.instance.logOut();
  }
}