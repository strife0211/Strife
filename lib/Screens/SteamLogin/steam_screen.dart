import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:steam_login/steam_login.dart';
import 'package:strife/Screens/Chat/controllers/chat_controller.dart';
import 'package:strife/Screens/Matching/controllers/matching_controller.dart';
import 'package:strife/Screens/Notification/controllers/notification_controller.dart';
import 'package:strife/Screens/Post/controllers/post_controller.dart';
import 'package:strife/Screens/Profile/controllers/profile_controller.dart';
import 'package:strife/Screens/SteamLogin/controllers/steam_controller.dart';

class SteamScreen extends StatelessWidget {
  final _webView = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SteamController());
    final profileController = Get.put(ProfileController());
    final matchingController = Get.put(MatchingController());
    final notificationController = Get.put(NotificationController());
    final chatController = Get.put(ChatController());
    final postController = Get.put(PostController());

    // Listen to the onUrlChanged events, and when we are ready to validate do so.
    _webView.onUrlChanged.listen((String url) async {
      var openId = OpenId.fromUri(Uri.parse(url));
      if (openId.mode == 'id_res') {
        await _webView.close();
        var steamID = await openId.validate();
        print("openId.validate()"+ steamID);
        await ProfileController.profile.readData();
        await ProfileController.profile.createGames(steamID);
        await MatchingController.matching.getUserList();
        await NotificationController.notification.readSenderUserDataList();
        await ChatController.chat.getMessage();
        await PostController.post.getAllPost();
        await SteamController.instance.steamToProfile(steamID);
      }
    });

    const _openIdMode = 'checkid_setup';
    const _openIdNs = 'http://specs.openid.net/auth/2.0';
    const _openIdIdentifier =
        'http://specs.openid.net/auth/2.0/identifier_select';

    final data = {
      'openid.claimed_id': _openIdIdentifier,
      'openid.identity': _openIdIdentifier,
      'openid.mode': _openIdMode,
      'openid.ns': _openIdNs,
    };

    var openId = OpenId.raw('https://myapp', 'https://myapp/', data);
    return WebviewScaffold(
        url: openId.authUrl().toString(),
        appBar: AppBar(backgroundColor: Colors.black,),
        );
  }
}