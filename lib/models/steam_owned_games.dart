class SteamOwnedGames {
  GameResponse? response;

  SteamOwnedGames({this.response});

  SteamOwnedGames.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new GameResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class GameResponse {
  int? gameCount;
  List<Games>? games;

  GameResponse({this.gameCount, this.games});

  GameResponse.fromJson(Map<String, dynamic> json) {
    gameCount = json['game_count'];
    if (json['games'] != null) {
      games = <Games>[];
      json['games'].forEach((v) {
        games!.add(new Games.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_count'] = this.gameCount;
    if (this.games != null) {
      data['games'] = this.games!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Games {
  int? appid;
  String? name;
  int? playtimeForever;
  String? imgIconUrl;
  int? rtimeLastPlayed;

  Games(
      {this.appid,
      this.name,
      this.playtimeForever,
      this.imgIconUrl,
      this.rtimeLastPlayed});

  Games.fromJson(Map<String, dynamic> json) {
    appid = json['appid'];
    name = json['name'];
    playtimeForever = json['playtime_forever'];
    imgIconUrl = json['img_icon_url'];
    rtimeLastPlayed = json['rtime_last_played'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appid'] = this.appid;
    data['name'] = this.name;
    data['playtime_forever'] = this.playtimeForever;
    data['img_icon_url'] = this.imgIconUrl;
    data['rtime_last_played'] = this.rtimeLastPlayed;
    return data;
  }
}