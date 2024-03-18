import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:steam_login/steam_login.dart';
import 'package:strife/services/authentication/authentication_services.dart';
import 'package:url_launcher/url_launcher.dart';

class SteamLoginController extends GetxController {
  static SteamLoginController get instance => Get.find();

  // final String steamLoginUrl = 'https://steamcommunity.com/openid/login';
  // final String steamReturnUrl = 'https://www.example.com/auth/steam';

  // String SteamLogin() {
  //   final String openIdUrl = steamLoginUrl +
  //         '?openid.ns=http://specs.openid.net/auth/2.0' +
  //         '&openid.mode=checkid_setup' +
  //         '&openid.return_to=' +
  //         Uri.encodeFull(steamReturnUrl) +
  //         '&openid.realm=' +
  //         Uri.encodeFull(steamReturnUrl) +
  //         '&openid.identity=http://specs.openid.net/auth/2.0/identifier_select' +
  //         '&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select';

  //     return openIdUrl;
  // }

  // Future<void> launchURL() async {

  //   print("LaunchURL");
  //   // Bind the HttpServer.
  // var server = await HttpServer.bind(
  //   InternetAddress.loopbackIPv4,
  //   8080,
  // );
  //   print("LaunchURL after");
  //   print("Server running on IP : "+server.address.toString()+" On Port : "+server.port.toString());


  // // Start listening for HttpRequests.
  // server.listen((request) async {
  //   print("Request");
  //   print(request.uri.path.toString());
  //   //Check if the path is '/login'
  //   if (request.uri.path == '/login') {
  //     // Create OpenId instance with the current request.
  //     OpenId openId = OpenId(request);

  //     // Switch the mode
  //     switch (openId.mode) {
  //       // No mode is set
  //       case '':
  //         {
  //           //Redirect the user to the authUrl.
  //           request.response
  //             ..redirect(openId.authUrl())
  //             ..close();
  //           break;
  //         }
  //       // Authentication failed/cancelled.
  //       case 'cancel':
  //         {
  //           request.response
  //             ..write('Auth cancelled')
  //             ..close();
  //           break;
  //         }
  //       // Usually mode = 'id_res'.
  //       default:
  //         {
  //           // Validate the authentication and the the steamid64.
  //           String? steamId = await openId.validate();

  //           // Save the steamid into the session.
  //           request.session['steamid'] = steamId;

  //           // Redirect the user.
  //           request.response
  //             ..redirect(Uri.parse('http://localhost'))
  //             ..close();
  //         }
  //     }
  //   } else {
  //     // Check if the user is already logged
  //     if (request.session['steamid'] == null) {
  //       request.response.write('Go to /login in order to log in!');
  //     } else {
  //       // If he's logged in display his steam display name.
  //       // Get the steamapi key here: https://steamcommunity.com/dev/apikey
  //       Map<String, dynamic>? summaries = await GetPlayerSummaries(
  //           request.session['steamid'], 'yoursteamapikey');
  //       request.response
  //           .write('Thanks for logging in: ${summaries['personname']}');
  //     }
  //     request.response.close();
  //   }
  // });
  
  //   // const steamLoginUrl = 'https://steamcommunity.com/openid/login';
  //   // const steamReturnUrl = 'https://www.example.com/auth/steam';

  //   // final openIdUrl = Uri.parse(steamLoginUrl +
  //   //         '?openid.ns=http://specs.openid.net/auth/2.0' +
  //   //         '&openid.mode=checkid_setup' +
  //   //         '&openid.return_to=' + Uri.encodeFull(steamReturnUrl) +
  //   //         '&openid.realm=' + Uri.encodeFull(steamReturnUrl) +
  //   //         '&openid.identity=http://specs.openid.net/auth/2.0/identifier_select' +
  //   //         '&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select'
  //   //         );
  //   // if (await canLaunchUrl(openIdUrl)) {
  //   //   await launchUrl(openIdUrl);
  //   // } else {
  //   //   throw 'Could not launch $openIdUrl';
  //   // }
  // }

  void steamSignIn() {
    AuthenticationService.instance.steamSignIn();
  }

  void signOut() {
    AuthenticationService.instance.logOut();
  }
  
}