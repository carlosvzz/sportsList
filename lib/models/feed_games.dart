class FeedGames {
  Dailygameschedule dailygameschedule;

  FeedGames({Dailygameschedule dailygameschedule}) {
    this.dailygameschedule = dailygameschedule;
  }


  FeedGames.fromJson(Map<String, dynamic> json) {
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
  AwayTeam awayTeam;
  HomeTeam homeTeam;
  String location;

  Gameentry(
      {String id,
      String scheduleStatus,
      String originalDate,
      String originalTime,
      String delayedOrPostponedReason,
      String date,
      String time,
      AwayTeam awayTeam,
      HomeTeam homeTeam,
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
    awayTeam = json['awayTeam'] != null
        ? new AwayTeam.fromJson(json['awayTeam'])
        : null;
    homeTeam = json['homeTeam'] != null
        ? new HomeTeam.fromJson(json['homeTeam'])
        : null;
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

class AwayTeam {
  String iD;
  String city;
  String name;
  String abbreviation;

  AwayTeam({String iD, String city, String name, String abbreviation}) {
    this.iD = iD;
    this.city = city;
    this.name = name;
    this.abbreviation = abbreviation;
  }

  AwayTeam.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    city = json['City'];
    name = json['Name'];
    abbreviation = json['Abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['City'] = this.city;
    data['Name'] = this.name;
    data['Abbreviation'] = this.abbreviation;
    return data;
  }
}

class HomeTeam {
  String iD;
  String city;
  String name;
  String abbreviation;

  HomeTeam({String iD, String city, String name, String abbreviation}) {
    this.iD = iD;
    this.city = city;
    this.name = name;
    this.abbreviation = abbreviation;
  }

  HomeTeam.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    city = json['City'];
    name = json['Name'];
    abbreviation = json['Abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['City'] = this.city;
    data['Name'] = this.name;
    data['Abbreviation'] = this.abbreviation;
    return data;
  }
}