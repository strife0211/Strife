import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/SteamLogin/components/Login_logout_btn.dart';
import 'package:strife/Screens/SteamLogin/components/steam_login_image.dart';
import 'package:strife/Screens/SteamLogin/controllers/steam_login_controller.dart';
import 'package:strife/components/background.dart';
import 'package:url_launcher/url_launcher.dart';

class SteamLoginScreen extends StatefulWidget {
  const SteamLoginScreen({super.key});

  @override
  State<SteamLoginScreen> createState() => _SteamLoginScreenState();
}

class _SteamLoginScreenState extends State<SteamLoginScreen> {
  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(SteamLoginController());

    return Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SteamLoginImage(),
              Row(
                children: const [
                  Spacer(),
                  Expanded(
                    flex: 8,
                    child: LoginAndLogoutBtn(),
                  ),
                  Spacer(),
                ],
              ),
            ],
          )
        ),
      )
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Steam Login"),
    //   ),
    //   body: Container(
    //     child: Column(
    //       children: [
    //         Container(
    //           child: ElevatedButton(
    //             child: Text("Log out"),
    //             onPressed : () {
    //               SteamLoginController.instance.signOut();
    //             },
    //           ),
    //         ),
    //         Container(
    //           child: ElevatedButton(
    //             child: Text("Steam Login"),
    //             onPressed : SteamLoginController.instance.launchURL,
    //           ),
    //         )
    //       ],
    //     ),
    //   )
    // );
  }

  // Future<void> _launchURL() async {
  //   const steamLoginUrl = 'https://steamcommunity.com/openid/login';
  //   const steamReturnUrl = 'https://www.example.com/auth/steam';

  //   final openIdUrl = Uri.parse(steamLoginUrl +
  //           '?openid.ns=http://specs.openid.net/auth/2.0' +
  //           '&openid.mode=checkid_setup' 
  //           +
  //           '&openid.return_to=' +
  //           Uri.encodeFull(steamReturnUrl) +
  //           '&openid.realm=' +
  //           Uri.encodeFull(steamReturnUrl) +
  //           '&openid.identity=http://specs.openid.net/auth/2.0/identifier_select' +
  //           '&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select'
  //           );
  //   if (await canLaunchUrl(openIdUrl)) {
  //     await launchUrl(openIdUrl);
  //   } else {
  //     throw 'Could not launch $openIdUrl';
  //   }
  // }

  //  _launchURL() async {
  // const steamLoginUrl = 'https://steamcommunity.com/openid/login';
  // const steamReturnUrl = 'https://www.example.com/auth/steam';

  // final openIdUrl = Uri.parse(steamLoginUrl +
  //         '?openid.ns=http://specs.openid.net/auth/2.0' +
  //         '&openid.mode=checkid_setup' 
  //         +
  //         '&openid.return_to=' +
  //         Uri.encodeFull(steamReturnUrl) +
  //         '&openid.realm=' +
  //         Uri.encodeFull(steamReturnUrl) +
  //         '&openid.identity=http://specs.openid.net/auth/2.0/identifier_select' +
  //         '&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select'
  //         );

  // const url = 'https://www.google.com/';
  // final uri = Uri.parse(url);
  // if (await canLaunchUrl(uri)) {
  //   await launchUrl(uri);
  // } else {
  //   throw 'Could not launch $url';
  // }

  // if (await canLaunchUrl(openIdUrl)) {
  //   await launchUrl(openIdUrl);
  // } else {
  //   throw 'Could not launch $openIdUrl';
  // }s
// }
}

 
