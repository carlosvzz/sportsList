import 'package:flutter/material.dart';
import 'package:sports_list/models/feed_games.dart';

class Game {
  String idSport;
  int idGame;
  DateTime date;
  String time;
  String scheduleStatus;
  String originalTime;
  AwayTeam awayTeam;
  HomeTeam homeTeam;
  String location;
  int countHome;
  int countAway;
  int countDraw;
  int countOver;
  int countUnder;
  Color colorHome;
  Color colorAway;
  Color colorDraw;
  Color colorOver;
  Color colorUnder;

  Game(
      {this.idSport,
      this.idGame,
      this.date,
      this.time,
      this.scheduleStatus,
      this.originalTime,
      this.awayTeam,
      this.homeTeam,
      this.location,
      this.countHome = 0,
      this.countAway = 0,
      this.countDraw = 0,
      this.countOver = 0,
      this.countUnder = 0,
      this.colorHome = Colors.white,
      this.colorAway = Colors.white,
      this.colorDraw = Colors.white,
      this.colorOver = Colors.white,
      this.colorUnder = Colors.white});
}
