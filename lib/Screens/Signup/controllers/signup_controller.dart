import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strife/services/authentication/authentication_services.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  
  final email = TextEditingController();
  final password = TextEditingController();
  late String errorMessage;

  Future<bool> registerUser(String email, String password) async{
    bool validUser = await AuthenticationService.instance.createUserWithEmailAndPassword(email, password);
    return validUser;
  }
}