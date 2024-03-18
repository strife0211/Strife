import 'package:get/get.dart';
import 'package:strife/models/user.dart';
import 'package:strife/services/authentication/authentication_services.dart';
import 'package:strife/services/profile/profile_services.dart';

class SteamController extends GetxController {
  static SteamController get instance => Get.find();
  // static SteamController get profile => Get.find();
  
  // late String currentUserUid;
  // late MyUser userData;

  // Future<void> readData() async {
  //   currentUserUid = await Profile.profile.getCurrentUID();
  //   userData = await Profile.profile.getUserData(currentUserUid);
  // }

  Future <void> steamToProfile(String steamID) async {
    await AuthenticationService.instance.updateUid(steamID);
    await AuthenticationService.instance.steamToProfile();
  }
}