import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/models/team.dart';
import 'fixture_sportsfeed.dart';

class FixturesApiFootball {
  Api api;

  FixturesApiFootball({this.api});

  FixturesApiFootball.fromJson(Map<String, dynamic> json) {
    api = json['api'] != null ? new Api.fromJson(json['api']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.api != null) {
      data['api'] = this.api.toJson();
    }
    return data;
  }
}

class Api {
  int results;
  List<Fixtures> fixtures;

  Api({this.results, this.fixtures});

  Api.fromJson(Map<String, dynamic> json) {
    results = json['results'];
    if (json['fixtures'] != null) {
      fixtures = new List<Fixtures>();
      json['fixtures'].forEach((v) {
        fixtures.add(new Fixtures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = this.results;
    if (this.fixtures != null) {
      data['fixtures'] = this.fixtures.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fixtures {
  int fixtureId;
  int leagueId;
  String eventDate;
  int eventTimestamp;
  int firstHalfStart;
  int secondHalfStart;
  String round;
  String status;
  String statusShort;
  int elapsed;
  String venue;
  String referee;
  Team homeTeam;
  Team awayTeam;
  int goalsHomeTeam;
  int goalsAwayTeam;
  Score score;

  Fixtures(
      {this.fixtureId,
      this.leagueId,
      this.eventDate,
      this.eventTimestamp,
      this.firstHalfStart,
      this.secondHalfStart,
      this.round,
      this.status,
      this.statusShort,
      this.elapsed,
      this.venue,
      this.referee,
      this.homeTeam,
      this.awayTeam,
      this.goalsHomeTeam,
      this.goalsAwayTeam,
      this.score});

  Fixtures.fromJson(Map<String, dynamic> json) {
    fixtureId = json['fixture_id'];
    leagueId = json['league_id'];
    eventDate = json['event_date'];
    eventTimestamp = json['event_timestamp'];
    firstHalfStart = json['firstHalfStart'];
    secondHalfStart = json['secondHalfStart'];
    round = json['round'];
    status = json['status'];
    statusShort = json['statusShort'];
    elapsed = json['elapsed'];
    venue = json['venue'];
    referee = json['referee'];
    homeTeam = json['homeTeam'] != null
        ? new Team.fromJsonAPIFootball(json['homeTeam'])
        : null;
    awayTeam = json['awayTeam'] != null
        ? new Team.fromJsonAPIFootball(json['awayTeam'])
        : null;
    goalsHomeTeam = json['goalsHomeTeam'];
    goalsAwayTeam = json['goalsAwayTeam'];
    score = json['score'] != null ? new Score.fromJson(json['score']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fixture_id'] = this.fixtureId;
    data['league_id'] = this.leagueId;
    data['event_date'] = this.eventDate;
    data['event_timestamp'] = this.eventTimestamp;
    data['firstHalfStart'] = this.firstHalfStart;
    data['secondHalfStart'] = this.secondHalfStart;
    data['round'] = this.round;
    data['status'] = this.status;
    data['statusShort'] = this.statusShort;
    data['elapsed'] = this.elapsed;
    data['venue'] = this.venue;
    data['referee'] = this.referee;
    if (this.homeTeam != null) {
      data['homeTeam'] = this.homeTeam.toJson();
    }
    if (this.awayTeam != null) {
      data['awayTeam'] = this.awayTeam.toJson();
    }
    data['goalsHomeTeam'] = this.goalsHomeTeam;
    data['goalsAwayTeam'] = this.goalsAwayTeam;
    if (this.score != null) {
      data['score'] = this.score.toJson();
    }
    return data;
  }

  // GameEntry, clase general de fixtures
  Gameentry toGameentry() {
    //event_Date viene como fecha ISO8601 2019-08-24T16:05:00Z (en zona UTC)
    DateTime dateGame = DateTime.parse(this.eventDate).toLocal();

    return new Gameentry(
        id: this.fixtureId.toString(),
        scheduleStatus: 'Normal',
        originalDate: null,
        originalTime: null,
        delayedOrPostponedReason: null,
        date: formatDate(dateGame, [yyyy, '-', mm, '-', dd]),
        time: formatDate(dateGame, [HH, ':', nn]),
        location: this.venue,
        awayTeam: this.awayTeam,
        homeTeam: this.homeTeam);
  }
}

class Score {
  String halftime;
  String fulltime;
  Null extratime;
  Null penalty;

  Score({this.halftime, this.fulltime, this.extratime, this.penalty});

  Score.fromJson(Map<String, dynamic> json) {
    halftime = json['halftime'];
    fulltime = json['fulltime'];
    extratime = json['extratime'];
    penalty = json['penalty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['halftime'] = this.halftime;
    data['fulltime'] = this.fulltime;
    data['extratime'] = this.extratime;
    data['penalty'] = this.penalty;
    return data;
  }
}
