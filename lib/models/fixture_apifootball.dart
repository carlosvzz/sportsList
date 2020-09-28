import 'package:XSports/helpers/format_date.dart';
import 'package:XSports/models/team.dart';
import 'fixture_sportsfeed.dart';

class FixturesApiFootball {
  Parameters parameters;
  int results;
  List<Response> response;

  FixturesApiFootball({this.parameters, this.results, this.response});

  FixturesApiFootball.fromJson(Map<String, dynamic> json) {
    parameters = json['parameters'] != null
        ? new Parameters.fromJson(json['parameters'])
        : null;

    results = json['results'];
    if (json['response'] != null) {
      response = new List<Response>();
      json['response'].forEach((v) {
        response.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parameters != null) {
      data['parameters'] = this.parameters.toJson();
    }

    data['results'] = this.results;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parameters {
  String league;
  String to;
  String from;
  String timezone;
  String season;

  Parameters({this.league, this.to, this.from, this.timezone, this.season});

  Parameters.fromJson(Map<String, dynamic> json) {
    league = json['league'];
    to = json['to'];
    from = json['from'];
    timezone = json['timezone'];
    season = json['season'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['league'] = this.league;
    data['to'] = this.to;
    data['from'] = this.from;
    data['timezone'] = this.timezone;
    data['season'] = this.season;
    return data;
  }
}

class Response {
  Fixture fixture;
  League league;
  Teams teams;
  Goals goals;
  Score score;

  Response({this.fixture, this.league, this.teams, this.goals, this.score});

  Response.fromJson(Map<String, dynamic> json) {
    fixture =
        json['fixture'] != null ? new Fixture.fromJson(json['fixture']) : null;
    league =
        json['league'] != null ? new League.fromJson(json['league']) : null;
    teams = json['teams'] != null ? new Teams.fromJson(json['teams']) : null;
    // goals = json['goals'] != null ? new Goals.fromJson(json['goals']) : null;
    // score = json['score'] != null ? new Score.fromJson(json['score']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fixture != null) {
      data['fixture'] = this.fixture.toJson();
    }
    if (this.league != null) {
      data['league'] = this.league.toJson();
    }
    if (this.teams != null) {
      data['teams'] = this.teams.toJson();
    }
    if (this.goals != null) {
      data['goals'] = this.goals.toJson();
    }
    if (this.score != null) {
      data['score'] = this.score.toJson();
    }
    return data;
  }

  // GameEntry, clase general de fixtures
  Gameentry toGameentry() {
    //event_Date viene como fecha ISO8601 2019-08-24T16:05:00Z (en zona UTC)
    DateTime dateGame = DateTime.parse(this.fixture.date).toLocal();

    return new Gameentry(
        id: this.fixture.id.toString(),
        scheduleStatus: 'Normal',
        date: formatDate(dateGame, [yyyy, '-', mm, '-', dd]),
        time: formatDate(dateGame, [HH, ':', nn]),
        awayTeam: this.teams.away,
        homeTeam: this.teams.home);
  }
}

class Fixture {
  int id;
  // String venue;
  String referee;
  String timezone;
  String date;
  int timestamp;
  Periods periods;
  Status status;

  Fixture(
      {this.id,
      // this.venue,
      this.referee,
      this.timezone,
      this.date,
      this.timestamp,
      this.periods,
      this.status});

  Fixture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // venue =  json['venue'];
    referee = json['referee'];
    timezone = json['timezone'];
    date = json['date'];
    timestamp = json['timestamp'];
    periods =
        json['periods'] != null ? new Periods.fromJson(json['periods']) : null;
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    // data['venue'] = this.venue;
    data['referee'] = this.referee;
    data['timezone'] = this.timezone;
    data['date'] = this.date;
    data['timestamp'] = this.timestamp;
    if (this.periods != null) {
      data['periods'] = this.periods.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    return data;
  }
}

class Periods {
  int first;
  int second;

  Periods({this.first, this.second});

  Periods.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    second = json['second'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['second'] = this.second;
    return data;
  }
}

class Status {
  String long;
  String short;
  int elapsed;

  Status({this.long, this.short, this.elapsed});

  Status.fromJson(Map<String, dynamic> json) {
    long = json['long'];
    short = json['short'];
    elapsed = json['elapsed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long'] = this.long;
    data['short'] = this.short;
    data['elapsed'] = this.elapsed;
    return data;
  }
}

class League {
  int id;
  String name;
  String country;
  String logo;
  String flag;
  int season;
  String round;

  League(
      {this.id,
      this.name,
      this.country,
      this.logo,
      this.flag,
      this.season,
      this.round});

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    logo = json['logo'];
    flag = json['flag'];
    season = json['season'];
    round = json['round'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country'] = this.country;
    data['logo'] = this.logo;
    data['flag'] = this.flag;
    data['season'] = this.season;
    data['round'] = this.round;
    return data;
  }
}

class Teams {
  Team home;
  Team away;

  Teams({this.home, this.away});

  Teams.fromJson(Map<String, dynamic> json) {
    home = json['home'] != null
        ? new Team.fromJsonAPIFootball(json['home'])
        : null;
    away = json['away'] != null
        ? new Team.fromJsonAPIFootball(json['away'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.home != null) {
      data['home'] = this.home.toJson();
    }
    if (this.away != null) {
      data['away'] = this.away.toJson();
    }
    return data;
  }
}

class Goals {
  int home;
  int away;

  Goals({this.home, this.away});

  Goals.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home'] = this.home;
    data['away'] = this.away;
    return data;
  }
}

class Score {
  Goals halftime;
  Fulltime fulltime;
  Fulltime extratime;
  Fulltime penalty;

  Score({this.halftime, this.fulltime, this.extratime, this.penalty});

  Score.fromJson(Map<String, dynamic> json) {
    halftime =
        json['halftime'] != null ? new Goals.fromJson(json['halftime']) : null;
    fulltime = json['fulltime'] != null
        ? new Fulltime.fromJson(json['fulltime'])
        : null;
    extratime = json['extratime'] != null
        ? new Fulltime.fromJson(json['extratime'])
        : null;
    penalty =
        json['penalty'] != null ? new Fulltime.fromJson(json['penalty']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.halftime != null) {
      data['halftime'] = this.halftime.toJson();
    }
    if (this.fulltime != null) {
      data['fulltime'] = this.fulltime.toJson();
    }
    if (this.extratime != null) {
      data['extratime'] = this.extratime.toJson();
    }
    if (this.penalty != null) {
      data['penalty'] = this.penalty.toJson();
    }
    return data;
  }
}

class Fulltime {
  Null home;
  Null away;

  Fulltime({this.home, this.away});

  Fulltime.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home'] = this.home;
    data['away'] = this.away;
    return data;
  }
}

// class FixturesApiFootball {
//   Api api;

//   FixturesApiFootball({this.api});

//   FixturesApiFootball.fromJson(Map<String, dynamic> json) {
//     api = json['api'] != null ? new Api.fromJson(json['api']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.api != null) {
//       data['api'] = this.api.toJson();
//     }
//     return data;
//   }
// }

// class Api {
//   int results;
//   List<Fixtures> fixtures;

//   Api({this.results, this.fixtures});

//   Api.fromJson(Map<String, dynamic> json) {
//     results = json['results'];
//     if (json['fixtures'] != null) {
//       fixtures = new List<Fixtures>();
//       json['fixtures'].forEach((v) {
//         fixtures.add(new Fixtures.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['results'] = this.results;
//     if (this.fixtures != null) {
//       data['fixtures'] = this.fixtures.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Fixtures {
//   int fixtureId;
//   int leagueId;
//   String eventDate;
//   int eventTimestamp;
//   String venue;
//   String referee;
//   Team homeTeam;
//   Team awayTeam;

//   Fixtures(
//       {this.fixtureId,
//       this.leagueId,
//       this.eventDate,
//       this.eventTimestamp,
//       this.venue,
//       this.referee,
//       this.homeTeam,
//       this.awayTeam});

//   Fixtures.fromJson(Map<String, dynamic> json) {
//     fixtureId = json['fixture_id'];
//     leagueId = json['league_id'];
//     eventDate = json['event_date'];
//     eventTimestamp = json['event_timestamp'];
//     venue = json['venue'];
//     referee = json['referee'];
//     homeTeam = json['homeTeam'] != null
//         ? new Team.fromJsonAPIFootball(json['homeTeam'])
//         : null;
//     awayTeam = json['awayTeam'] != null
//         ? new Team.fromJsonAPIFootball(json['awayTeam'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fixture_id'] = this.fixtureId;
//     data['league_id'] = this.leagueId;
//     data['event_date'] = this.eventDate;
//     data['event_timestamp'] = this.eventTimestamp;
//     data['venue'] = this.venue;
//     data['referee'] = this.referee;
//     if (this.homeTeam != null) {
//       data['homeTeam'] = this.homeTeam.toJson();
//     }
//     if (this.awayTeam != null) {
//       data['awayTeam'] = this.awayTeam.toJson();
//     }
//     return data;
//   }

//   // GameEntry, clase general de fixtures
//   Gameentry toGameentry() {
//     //event_Date viene como fecha ISO8601 2019-08-24T16:05:00Z (en zona UTC)
//     DateTime dateGame = DateTime.parse(this.eventDate).toLocal();

//     return new Gameentry(
//         id: this.fixtureId.toString(),
//         scheduleStatus: 'Normal',
//         originalDate: null,
//         originalTime: null,
//         delayedOrPostponedReason: null,
//         date: formatDate(dateGame, [yyyy, '-', mm, '-', dd]),
//         time: formatDate(dateGame, [HH, ':', nn]),
//         location: this.venue,
//         awayTeam: this.awayTeam,
//         homeTeam: this.homeTeam);
//   }
// }
