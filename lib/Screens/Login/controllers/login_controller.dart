import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strife/services/authentication/authentication_services.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  late String errorMessage;
  // late bool validUser;


  Future<bool> signIn(String email, String password) async {
    // print("errorMessage");
    // print(errorMessage);
    bool validUser = await AuthenticationService.instance.signInWithEmailAndPassword(email, password);
    // print("errorMessage2");
    // print(errorMessage);
    // print("validUser");
    // print(validUser);
    return validUser;
  }
}