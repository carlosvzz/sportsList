import 'package:flutter/material.dart';
import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/models/team.dart';

class GameDb {
  String id;
  String idSport;
  int idGame;
  String date; // formato YYYY-MM-DD
  String time; // formato 24H 00:00
  String location;
  String homeTeamAbbrev;
  String homeTeamName;
  String awayTeamAbbrev;
  String awayTeamName;
  int countHome = 0;
  int countAway = 0;
  int countDraw = 0;
  int countOverUnder = 0; // over / under
  int countExtra = 0; // Extra segun sports (BTTS , Spread , etc)

  // Internas para colores. No se guardan en DB
  Color colorHome = Colors.white;
  Color colorAway = Colors.white;
  Color colorDraw = Colors.white;
  Color colorOverUnder = Colors.white;
  Color colorExtra = Colors.white;

  GameDb();

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id'] = id;
    map['idSport'] = idSport;
    map['idGame'] = idGame;
    map['date'] = date;
    map['time'] = time;
    map['location'] = location;
    map['awayTeamAbbrev'] = awayTeamAbbrev;
    map['awayTeamName'] = awayTeamName;
    map['homeTeamAbbrev'] = homeTeamAbbrev;
    map['homeTeamName'] = homeTeamName;
    map['countHome'] = countHome;
    map['countAway'] = countAway;
    map['countDraw'] = countDraw;
    map['countOverUnder'] = countOverUnder;
    map['countExtra'] = countExtra;

    return map;
  }

  GameDb.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.idSport = map['idSport'];
    this.idGame = map['idGame'];

    DateTime fecha = map['date'].toDate(); // Viene como TimeStamp;
    this.date = formatDate(
        fecha.toLocal(), [yyyy, '-', mm, '-', dd]); // Formato YYYY-MM-DD
    this.time = map['time'];
    this.location = map['location'];

    Team aTeam = new Team.fromJson(map['awayTeam']);
    Team hTeam = new Team.fromJson(map['HomeTeam']);
    this.awayTeamAbbrev = aTeam.abbreviation;
    this.awayTeamName = aTeam.name;
    this.homeTeamAbbrev = hTeam.abbreviation;
    this.homeTeamName = hTeam.name;

    this.countHome = map['countHome'];
    this.countAway = map['countAway'];
    this.countDraw = map['countDraw'];
    this.countOverUnder = map['countOverUnder'];
    this.countExtra = map['countExtra'];
  }

  GameDb fromMap(Map<String, dynamic> map) {
    var game = new GameDb();

    game.id = map['id'];
    game.idSport = map['idSport'];
    game.idGame = map['idGame'];
    game.date = map['date'];
    game.time = map['time'];
    game.location = map['location'];

    Team aTeam = new Team.fromJson(map['awayTeam']);
    Team hTeam = new Team.fromJson(map['HomeTeam']);
    game.awayTeamAbbrev = aTeam.abbreviation;
    game.awayTeamName = aTeam.name;
    game.homeTeamAbbrev = hTeam.abbreviation;
    game.homeTeamName = hTeam.name;

    game.countHome = map['countHome'];
    game.countAway = map['countAway'];
    game.countDraw = map['countDraw'];
    game.countOverUnder = map['countOverUnder'];
    game.countExtra = map['countExtra'];

    return game;
  }

  GameDb createNew() {
    return GameDb();
  }
} // Fin clase
