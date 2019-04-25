import 'package:flutter/material.dart';
import 'package:sports_list/models/basemodel.dart';
import 'package:sports_list/models/feed_games.dart';

class Game extends BaseModel {
  String _idSport;
  int _idGame;
  DateTime _date;
  String _time;  // formato 24H 00:00
  AwayTeam _awayTeam;
  HomeTeam _homeTeam;
  String _location;
  int countHome = 0;
  int countAway = 0;
  int countDraw = 0;
  int countOver = 0;
  int countUnder = 0;
  Color colorHome = Colors.white;
  Color colorAway = Colors.white;
  Color colorDraw = Colors.white;
  Color colorOver = Colors.white;
  Color colorUnder = Colors.white;

  Game();

  Game.fromValues(
    this._idSport,
    this._idGame,
    this._date,
    this._time,
    this._awayTeam,
    this._homeTeam,
    this._location,
  );

  String get idSport => _idSport;
  int get idGame => _idGame;
  DateTime get date => _date;
  String get time => _time;
  AwayTeam get awayTeam => _awayTeam;
  HomeTeam get homeTeam => _homeTeam;
  String get location => _location;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['idSport'] = _idSport;
    map['idGame'] = _idGame;
    map['date'] = _date;
    map['time'] = _time;
    map['awayTeam'] = _awayTeam.toJson();
    map['HomeTeam'] = _homeTeam.toJson();
    map['location'] = _location;
    map['countHome'] = countHome;
    map['countAway'] = countAway;
    map['countDraw'] = countDraw;
    map['countOver'] = countOver;
    map['countUnder'] = countUnder;

    return map;
  }

  Game.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this._idSport = map['idSport'];
    this._idGame = map['idGame'];
    this._date = map['date'].toDate(); // Viene como TimeStamp
    this._time = map['time'];
    this._awayTeam = new AwayTeam.fromJson(map['awayTeam']);
    this._homeTeam = new HomeTeam.fromJson(map['HomeTeam']);
    this._location = map['location'];
    this.countHome = map['countHome'];
    this.countAway = map['countAway'];
    this.countDraw = map['countDraw'];
    this.countOver = map['countOver'];
    this.countUnder = map['countUnder'];
  }

  Game fromMap(Map<String, dynamic> map) {
    var game = new Game();

    game.id = map['id'];
    game._idSport = map['idSport'];
    game._idGame = map['idGame'];
    game._date = map['date'];
    game._time = map['time'];
    game._awayTeam = new AwayTeam.fromJson(map['awayTeam']);
    game._homeTeam = new HomeTeam.fromJson(map['HomeTeam']);
    game._location = map['location'];
    game.countHome = map['countHome'];
    game.countAway = map['countAway'];
    game.countDraw = map['countDraw'];
    game.countOver = map['countOver'];
    game.countUnder = map['countUnder'];

    return game;
  }

  Game createNew() {
    return Game();
  }
} // Fin clase
