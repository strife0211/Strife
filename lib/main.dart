import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Welcome/welcome_screen.dart';
import 'package:strife/constants.dart';
import 'package:strife/firebase_options.dart';
import 'package:strife/services/authentication/authentication_services.dart';
import 'package:strife/services/chat/chat_services.dart';
import 'package:strife/services/matching/matching_services.dart';
import 'package:strife/services/notification/notification_services.dart';
import 'package:strife/services/post/post_services.dart';
import 'package:strife/services/profile/profile_services.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform 
  ).then((value) {
    Get.put(AuthenticationService());
    Get.put(ProfileService());
    Get.put(MatchingService());
    Get.put(NotificationService());
    Get.put(ChatService());
    Get.put(PostService());
    });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: const WelcomeScreen(),
    );
  }
}

