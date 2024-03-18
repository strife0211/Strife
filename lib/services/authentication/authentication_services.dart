import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Login/controllers/login_controller.dart';
import 'package:strife/Screens/Navigation/navigation.dart';
import 'package:strife/Screens/Profile/profile_screen.dart';
import 'package:strife/Screens/Signup/controllers/signup_controller.dart';
import 'package:strife/Screens/SteamLogin/steam_login_screen.dart';
import 'package:strife/Screens/SteamLogin/steam_screen.dart';
import 'package:strife/Screens/Welcome/welcome_screen.dart';
import 'package:strife/services/authentication/exceptions/login_email_password_failure.dart';
import 'package:strife/services/authentication/exceptions/signup_email_password_failure.dart';

class AuthenticationService extends GetxController {
  static AuthenticationService get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  CollectionReference user = FirebaseFirestore.instance.collection("user");
  Reference get firebaseStorage => FirebaseStorage.instance.ref();

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    // user == null ? Get.offAll(() => const WelcomeScreen()) : Get.offAll(() => const ProfileScreen());
    user == null ? Get.offAll(() => const WelcomeScreen()) : Get.offAll(() => const SteamLoginScreen());
  }

  Future<bool> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      dynamic uid = result.user!.uid;
      await createUserAccount(email, uid);
      // firebaseUser.value != null ? Get.offAll(() => const ProfileScreen()) : Get.to(() => const WelcomeScreen());
      firebaseUser.value != null ? Get.offAll(() => const SteamLoginScreen()) : Get.to(() => const WelcomeScreen());

      return true;
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');

      SignUpController.instance.errorMessage = ex.message;

      return false;

      throw ex;
    } catch (_){
      const ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');

      SignUpController.instance.errorMessage = ex.message;

      return false;

      throw ex;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // firebaseUser.value != null ? Get.offAll(() => const ProfileScreen()) : Get.to(() => const WelcomeScreen());
      firebaseUser.value != null ? Get.offAll(() => const SteamLoginScreen()) : Get.to(() => const WelcomeScreen());
      print("firebaseUser.value");
      print(firebaseUser.value);

      return true;
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');

      LoginController.instance.errorMessage = ex.message;

      return false;

      throw ex;
    } catch (_){
      const ex = LoginWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');

      LoginController.instance.errorMessage = ex.message;

      return false;

      throw ex;
    }
  }

  Future<void> createUserAccount(String email, String uid) async {
    String rng = Random().nextInt(1000000).toString().padLeft(6, '0');
    print("RNG: " + rng);
    String name = "Anonymous#"+rng;

    var urlRef = firebaseStorage.child('Default_Profile.png');
    String url = await urlRef.getDownloadURL();
    print("Image URL: " + url);
    
    await user.doc(uid).set({
      "name": name,
      "email": email,
      "gender": "Hidden",
      "age": 0,
      'address':"Address",
      "phone" : "Phone Number",
      "steamID" : "SteamID",
      "url": url,
      "about": "This user does not write about himself",
      "friend": [],
    }).then((value) => print("User is add"))
    .catchError((error) => print("Failed to add user: $error"));
  }

  Future <void> updateUid(String _UID) async {
    DocumentReference userInfo = user.doc(FirebaseAuth.instance.currentUser!.uid);

    await userInfo.update({
        "steamID" : _UID,
      }
    ).then((value) => print("User SteamID Updated!")).catchError((error)=>print("Fail!"));
    // user.doc().set(
    // {
    //   'name': name,
    //   'phone':phone,
    //   'address':address,
    //   'url': url,
    // }).then((value) => print("User Added"))
    //   .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> steamSignIn() async {
      Get.to(() => SteamScreen());
  }

  Future<void> steamToProfile() async {
      Get.to(() => NavigationScreen());
  }


  Future<void> logOut() async => await _auth.signOut();
}