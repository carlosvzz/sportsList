import 'package:flutter/material.dart';
import 'package:sports_list/helpers/format_date.dart';
//import 'package:sports_list/models/basemodel.dart';
import 'package:sports_list/models/team.dart';

class Game {
  String id;
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

  String get dateFormat {
    return formatDate(_date, [yyyy, '-', mm, '-', dd]);
  }

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

  Map<String, dynamic> toMapDatabase() {
    var map = new Map<String, dynamic>();

    map['id'] = id;
    map['idSport'] = idSport;
    map['idGame'] = idGame;
    map['date'] = dateFormat;
    map['time'] = time;
    map['location'] = location;
    map['awayTeamAbbrev'] = _awayTeam.abbreviation;
    map['awayTeamName'] = _awayTeam.name;
    map['homeTeamAbbrev'] = _homeTeam.abbreviation;
    map['homeTeamName'] = _homeTeam.name;
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

  Game.fromMapDatabase(Map<String, dynamic> map) {
    DateTime dateGame = DateTime.parse(map['date']);
    Team awayT = new Team(
        mName: map['awayTeamName'], mAbbreviation: map['awayTeamAbbrev']);
    Team homeT = new Team(
        mName: map['homeTeamName'], mAbbreviation: map['homeTeamAbbrev']);

    this.id = map['id'];
    this._idSport = map['idSport'];
    this._idGame = map['idGame'];
    this._date = dateGame;
    this._time = map['time'];
    this._awayTeam = awayT;
    this._homeTeam = homeT;
    this._location = map['location'];
    this.countHome = map['countHome'];
    this.countAway = map['countAway'];
    this.countDraw = map['countDraw'];
    this.countOverUnder = map['countOverUnder'];
    this.countExtra = map['countExtra'];
  }

  Game createNew() {
    return Game();
  }
} // Fin clase
