import 'package:sports_list/models/team.dart';

class FixtureSportsFeed {
  Dailygameschedule dailygameschedule;

  FixtureSportsFeed({Dailygameschedule dailygameschedule}) {
    this.dailygameschedule = dailygameschedule;
  }

  FixtureSportsFeed.fromJson(Map<String, dynamic> json) {
    dailygameschedule = json['dailygameschedule'] != null
        ? new Dailygameschedule.fromJson(json['dailygameschedule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dailygameschedule != null) {
      data['dailygameschedule'] = this.dailygameschedule.toJson();
    }
    return data;
  }
}

class Dailygameschedule {
  String lastUpdatedOn;
  List<Gameentry> gameentry;

  Dailygameschedule({String lastUpdatedOn, List<Gameentry> gameentry}) {
    this.lastUpdatedOn = lastUpdatedOn;
    this.gameentry = gameentry;
  }

  Dailygameschedule.fromJson(Map<String, dynamic> json) {
    lastUpdatedOn = json['lastUpdatedOn'];
    if (json['gameentry'] != null) {
      gameentry = new List<Gameentry>();
      json['gameentry'].forEach((v) {
        gameentry.add(new Gameentry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdatedOn'] = this.lastUpdatedOn;
    if (this.gameentry != null) {
      data['gameentry'] = this.gameentry.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gameentry {
  String iD;
  String scheduleStatus;
  String originalDate;
  String originalTime;
  String delayedOrPostponedReason;
  String date;
  String time;
  Team awayTeam;
  Team homeTeam;
  String location;

  Gameentry(
      {String id,
      String scheduleStatus,
      String originalDate,
      String originalTime,
      String delayedOrPostponedReason,
      String date,
      String time,
      Team awayTeam,
      Team homeTeam,
      String location}) {
    this.iD = id;
    this.scheduleStatus = scheduleStatus;
    this.originalDate = originalDate;
    this.originalTime = originalTime;
    this.delayedOrPostponedReason = delayedOrPostponedReason;
    this.date = date;
    this.time = time;
    this.awayTeam = awayTeam;
    this.homeTeam = homeTeam;
    this.location = location;
  }

  Gameentry.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    scheduleStatus = json['scheduleStatus'];
    originalDate = json['originalDate'];
    originalTime = json['originalTime'];
    delayedOrPostponedReason = json['delayedOrPostponedReason'];
    date = json['date'];
    time = json['time'];
    awayTeam =
        json['awayTeam'] != null ? new Team.fromJson(json['awayTeam']) : null;
    homeTeam =
        json['homeTeam'] != null ? new Team.fromJson(json['homeTeam']) : null;
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.iD;
    data['scheduleStatus'] = this.scheduleStatus;
    data['originalDate'] = this.originalDate;
    data['originalTime'] = this.originalTime;
    data['delayedOrPostponedReason'] = this.delayedOrPostponedReason;
    data['date'] = this.date;
    data['time'] = this.time;
    if (this.awayTeam != null) {
      data['awayTeam'] = this.awayTeam.toJson();
    }
    if (this.homeTeam != null) {
      data['homeTeam'] = this.homeTeam.toJson();
    }
    data['location'] = this.location;
    return data;
  }
}
