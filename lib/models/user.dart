import 'package:strife/models/steam_owned_games.dart';

class MyUser {
  String uid;
  String name;
  String email;
  String gender;
  int age;
  String address;
  String phone;
  String steamID;
  String url;
  String about;
  List<Games>? games;
  List<Games>? sameGames;
  List<String>? friends;

  MyUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.address,
    required this.phone,
    required this.steamID,
    required this.url,
    required this.about,
    this.games,
    this.sameGames,
    this.friends
  });
}