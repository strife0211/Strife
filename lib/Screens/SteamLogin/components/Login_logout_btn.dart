import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:steam_login/steam_login.dart';
import 'package:strife/Screens/Profile/controllers/profile_controller.dart';
import 'package:strife/Screens/SteamLogin/controllers/steam_login_controller.dart';

import '../../../constants.dart';


class LoginAndLogoutBtn extends StatelessWidget {
  const LoginAndLogoutBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SteamLoginController());
    final profileController = Get.put(ProfileController());
    
    return Column(
      children: [
        Hero(
          tag: "Steam_Authentication_btn",
          child: ElevatedButton(
            onPressed: 
            ()
            //  async 
            {
                // // Navigate to the login page.
                // final result = await Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => SteamLogin()));
                SteamLoginController.instance.steamSignIn();
              },
            // SteamLoginController.instance.launchURL,
            // launchURL,
            child: Text(
              "Steam Authentication".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            SteamLoginController.instance.signOut();
          },
          style: ElevatedButton.styleFrom(
              primary: kPrimaryLightColor, elevation: 0),
          child: Text(
            "Logout".toUpperCase(),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

Future<void> launchURL() async {

    print("LaunchURL");
    // Bind the HttpServer.
  var server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    8080,
  );
    print("LaunchURL after");
    print("Server running on IP : "+server.address.toString()+" On Port : "+server.port.toString());


  // Start listening for HttpRequests.
  server.listen((request) async {
    print("Request");
    print(request.uri.path.toString());
    //Check if the path is '/login'
    if (request.uri.path == '/login') {
      // Create OpenId instance with the current request.
      OpenId openId = OpenId(request);

      // Switch the mode
      switch (openId.mode) {
        // No mode is set
        case '':
          {
            //Redirect the user to the authUrl.
            request.response
              ..redirect(openId.authUrl())
              ..close();
            break;
          }
        // Authentication failed/cancelled.
        case 'cancel':
          {
            request.response
              ..write('Auth cancelled')
              ..close();
            break;
          }
        // Usually mode = 'id_res'.
        default:
          {
            // Validate the authentication and the the steamid64.
            String? steamId = await openId.validate();

            // Save the steamid into the session.
            request.session['steamid'] = steamId;

            // Redirect the user.
            request.response
              ..redirect(Uri.parse('http://localhost'))
              ..close();
          }
      }
    } else {
      // Check if the user is already logged
      if (request.session['steamid'] == null) {
        request.response.write('Go to /login in order to log in!');
      } else {
        // If he's logged in display his steam display name.
        // Get the steamapi key here: https://steamcommunity.com/dev/apikey
        Map<String, dynamic>? summaries = await GetPlayerSummaries(
            request.session['steamid'], 'yoursteamapikey');
        request.response
            .write('Thanks for logging in: ${summaries['personname']}');
      }
      request.response.close();
    }
  });
}

// class SteamLogin extends StatelessWidget {
//   final _webView = FlutterWebviewPlugin();

//   @override
//   Widget build(BuildContext context) {
//     // Listen to the onUrlChanged events, and when we are ready to validate do so.
//     _webView.onUrlChanged.listen((String url) async {
//       var openId = OpenId.fromUri(Uri.parse(url));
//       if (openId.mode == 'id_res') {
//         await _webView.close();
//         Navigator.of(context).pop(openId.validate());
//       }
//     });

//     var openId = OpenId.raw('https://myapp', 'https://myapp/', null);
//     return WebviewScaffold(
//         url: openId.authUrl().toString(),
//         appBar: AppBar(
//           title: Text('Steam Login'),
//         ));
//   }
// }