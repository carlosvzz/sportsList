import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/models/team.dart';

import 'fixture_sportsfeed.dart';

class FixturesRunDown {
  Meta meta;
  List<EventsRunDown> events;

  FixturesRunDown({this.meta, this.events});

  FixturesRunDown.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['events'] != null) {
      events = new List<EventsRunDown>();
      json['events'].forEach((v) {
        events.add(new EventsRunDown.fromJson(v));
      });
    }
  }
}

class Meta {
  String deltaLastId;
  Meta({this.deltaLastId});
  Meta.fromJson(Map<String, dynamic> json) {
    deltaLastId = json['delta_last_id'];
  }
}

class EventsRunDown {
  String eventId;
  String eventDate;
  List<Teams> teams;
  List<TeamsNormalized> teamsNormalized;

  EventsRunDown(
      {this.eventId, this.eventDate, this.teams, this.teamsNormalized});

  EventsRunDown.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventDate = json['event_date'];
    if (json['teams'] != null) {
      teams = new List<Teams>();
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
    if (json['teams_normalized'] != null) {
      teamsNormalized = new List<TeamsNormalized>();
      json['teams_normalized'].forEach((v) {
        teamsNormalized.add(new TeamsNormalized.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_date'] = this.eventDate;
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    if (this.teamsNormalized != null) {
      data['teams_normalized'] =
          this.teamsNormalized.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Gameentry toGameentry() {
    //eventDate viene como fecha ISO8601 2019-08-24T16:05:00Z (en zona UTC)
    DateTime dateGame = DateTime.parse(this.eventDate).toLocal();

    // Buscar datos para equipos
    Team awayTeam = new Team();
    Team homeTeam = new Team();
    int ixHome;
    int ixAway;

    if (this.teams[0].isHome == true) {
// Equipo 1 es local
      if (this.teams[0].teamNormalizedId == this.teamsNormalized[0].teamId) {
        ixHome = 0;
        ixAway = 1;
      } else {
        ixHome = 1;
        ixAway = 0;
      }
    } else {
// Equipo 1 es visitante
      if (this.teams[0].teamNormalizedId == this.teamsNormalized[0].teamId) {
        ixHome = 1;
        ixAway = 0;
      } else {
        ixHome = 0;
        ixAway = 1;
      }
    }

    String abrev;
    abrev = this.teamsNormalized[ixHome].abbreviation;
    if (abrev.length > 3) {
      abrev = abrev.substring(0, 3);
    }

    homeTeam.idTeam = this.teamsNormalized[ixHome].teamId.toString();
    homeTeam.name = this.teamsNormalized[ixHome].mascot +
        ' ' +
        this.teamsNormalized[ixHome].name;
    homeTeam.abbreviation = abrev;

    abrev = this.teamsNormalized[ixAway].abbreviation;
    if (abrev.length > 3) {
      abrev = abrev.substring(0, 3);
    }
    awayTeam.idTeam = this.teamsNormalized[ixAway].teamId.toString();
    awayTeam.name = this.teamsNormalized[ixAway].mascot +
        ' ' +
        this.teamsNormalized[ixAway].name;
    awayTeam.abbreviation = abrev;

    return new Gameentry(
        id: (this.teams[0].teamId + this.teams[1].teamId).toString(),
        scheduleStatus: 'Normal',
        originalDate: null,
        originalTime: null,
        delayedOrPostponedReason: null,
        date: formatDate(dateGame, [yyyy, '-', mm, '-', dd]),
        time: formatDate(dateGame, [HH, ':', nn]),
        location: '',
        awayTeam: awayTeam,
        homeTeam: homeTeam);
  }
}

class Teams {
  int teamId;
  int teamNormalizedId;
  bool isAway;
  bool isHome;
  String name;

  Teams(
      {this.teamId,
      this.teamNormalizedId,
      this.isAway,
      this.isHome,
      this.name});

  Teams.fromJson(Map<String, dynamic> json) {
    teamId = json['team_id'];
    teamNormalizedId = json['team_normalized_id'];
    isAway = json['is_away'];
    isHome = json['is_home'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_id'] = this.teamId;
    data['team_normalized_id'] = this.teamNormalizedId;
    data['is_away'] = this.isAway;
    data['is_home'] = this.isHome;
    data['name'] = this.name;
    return data;
  }
}

class TeamsNormalized {
  int teamId;
  String name;
  String mascot;
  String abbreviation;
  String logoUrl;

  TeamsNormalized(
      {this.teamId, this.name, this.mascot, this.abbreviation, this.logoUrl});

  TeamsNormalized.fromJson(Map<String, dynamic> json) {
    teamId = json['team_id'];
    name = json['name'];
    mascot = json['mascot'];
    abbreviation = json['abbreviation'];
    logoUrl = json['logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_id'] = this.teamId;
    data['name'] = this.name;
    data['mascot'] = this.mascot;
    data['abbreviation'] = this.abbreviation;
    data['logo_url'] = this.logoUrl;
    return data;
  }
}
