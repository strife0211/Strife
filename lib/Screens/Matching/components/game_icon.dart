import 'package:flutter/material.dart';
import 'package:strife/models/steam_owned_games.dart';
import 'package:strife/models/user.dart';

class GameIcon extends StatelessWidget {
  const GameIcon({
    super.key,
    required this.game,
  });

  final Games game;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        right: 8,
      ),
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("http://media.steampowered.com/steamcommunity/public/images/apps/${game.appid}/${game.imgIconUrl}.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}