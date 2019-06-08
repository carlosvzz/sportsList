import 'package:flutter/material.dart';
import 'package:sports_list/models/basemodel.dart';
import 'package:sports_list/models/team.dart';

class Game extends BaseModel {
  String _idSport;
  int _idGame;
  DateTime _date;
  String _time; // formato 24H 00:00
  Team _awayTeam;
  Team _homeTeam;
  String _location;
  int countHome = 0;
  int countAway = 0;
  int countDraw = 0;
  int countOverUnder = 0; // over / under
  int countExtra = 0; // Extra segun sports (BTTS , Spread , etc)
  Color colorHome = Colors.white;
  Color colorAway = Colors.white;
  Color colorDraw = Colors.white;
  Color colorOverUnder = Colors.white;
  Color colorExtra = Colors.white;

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
  Team get awayTeam => _awayTeam;
  Team get homeTeam => _homeTeam;
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
    map['countOverUnder'] = countOverUnder;
    map['countExtra'] = countExtra;

    return map;
  }

  Game.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this._idSport = map['idSport'];
    this._idGame = map['idGame'];
    this._date = map['date'].toDate(); // Viene como TimeStamp
    this._time = map['time'];
    this._awayTeam = new Team.fromJson(map['awayTeam']);
    this._homeTeam = new Team.fromJson(map['HomeTeam']);
    this._location = map['location'];
    this.countHome = map['countHome'];
    this.countAway = map['countAway'];
    this.countDraw = map['countDraw'];
    this.countOverUnder = map['countOverUnder'];
    this.countExtra = map['countExtra'];
  }

  Game fromMap(Map<String, dynamic> map) {
    var game = new Game();

    game.id = map['id'];
    game._idSport = map['idSport'];
    game._idGame = map['idGame'];
    game._date = map['date'];
    game._time = map['time'];
    game._awayTeam = new Team.fromJson(map['awayTeam']);
    game._homeTeam = new Team.fromJson(map['HomeTeam']);
    game._location = map['location'];
    game.countHome = map['countHome'];
    game.countAway = map['countAway'];
    game.countDraw = map['countDraw'];
    game.countOverUnder = map['countOverUnder'];
    game.countExtra = map['countExtra'];

    return game;
  }

  Game createNew() {
    return Game();
  }
} // Fin clase
