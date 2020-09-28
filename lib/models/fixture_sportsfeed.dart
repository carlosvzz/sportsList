import 'package:XSports/helpers/format_date.dart';
import 'package:XSports/models/team.dart';

class FixtureSportsFeed {
  String lastUpdatedOn;
  List<Games> games;
  References references;

  FixtureSportsFeed({this.lastUpdatedOn, this.games, this.references});

  FixtureSportsFeed.fromJson(Map<String, dynamic> json) {
    lastUpdatedOn = json['lastUpdatedOn'];
    if (json['games'] != null) {
      games = new List<Games>();
      json['games'].forEach((v) {
        games.add(new Games.fromJson(v));
      });
    }
    references = json['references'] != null
        ? new References.fromJson(json['references'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdatedOn'] = this.lastUpdatedOn;
    if (this.games != null) {
      data['games'] = this.games.map((v) => v.toJson()).toList();
    }
    if (this.references != null) {
      data['references'] = this.references.toJson();
    }
    return data;
  }
}

class Games {
  Gameentry schedule;

  Games({this.schedule});

  Games.fromJson(Map<String, dynamic> json) {
    schedule = json['schedule'] != null
        ? new Gameentry.fromJson(json['schedule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schedule != null) {
      data['schedule'] = this.schedule.toJson();
    }
    return data;
  }
}

class Gameentry {
  String id;
  String date;
  String time;
  Team awayTeam;
  Team homeTeam;
  String scheduleStatus;

  Gameentry(
      {this.id,
      this.date,
      this.time,
      this.awayTeam,
      this.homeTeam,
      this.scheduleStatus});

  Gameentry.fromJson(Map<String, dynamic> json) {
    //event_Date viene como fecha ISO8601 2020-09-27T23:30:00.000Z (en zona UTC)
    DateTime dateGame = DateTime.parse(json['startTime']).toLocal();

    id = json['id'].toString();
    date = formatDate(dateGame, [yyyy, '-', mm, '-', dd]);
    time = formatDate(dateGame, [HH, ':', nn]);
    awayTeam = json['awayTeam'] != null
        ? new Team.fromJsonSportsFeed(json['awayTeam'])
        : null;
    homeTeam = json['homeTeam'] != null
        ? new Team.fromJsonSportsFeed(json['homeTeam'])
        : null;
    scheduleStatus = json['scheduleStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    if (this.awayTeam != null) {
      data['awayTeam'] = this.awayTeam.toJson();
    }
    if (this.homeTeam != null) {
      data['homeTeam'] = this.homeTeam.toJson();
    }
    data['scheduleStatus'] = this.scheduleStatus;
    return data;
  }
}

class References {
  List<TeamReferences> teamReferences;

  References({this.teamReferences});

  References.fromJson(Map<String, dynamic> json) {
    if (json['teamReferences'] != null) {
      teamReferences = new List<TeamReferences>();
      json['teamReferences'].forEach((v) {
        teamReferences.add(new TeamReferences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teamReferences != null) {
      data['teamReferences'] =
          this.teamReferences.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamReferences {
  int id;
  String city;
  String name;
  String abbreviation;
  List<String> teamColoursHex;
  String officialLogoImageSrc;

  TeamReferences(
      {this.id,
      this.city,
      this.name,
      this.abbreviation,
      this.teamColoursHex,
      this.officialLogoImageSrc});

  TeamReferences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    name = json['name'];
    abbreviation = json['abbreviation'];
    teamColoursHex = json['teamColoursHex'].cast<String>();
    officialLogoImageSrc = json['officialLogoImageSrc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['name'] = this.name;
    data['abbreviation'] = this.abbreviation;
    data['teamColoursHex'] = this.teamColoursHex;
    data['officialLogoImageSrc'] = this.officialLogoImageSrc;
    return data;
  }
}
