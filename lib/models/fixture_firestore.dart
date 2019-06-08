// clase de fixtures/juegos propios en firestore
import 'package:sports_list/models/team.dart';

class FixtureFireStore {
  int idGame;
  String idSport;
  int gameDate; //formato YYYYMMDD
  int gameStamp; //timestamp formato entero
  String location;
  Team awayTeam;
  Team homeTeam;

  FixtureFireStore(
      {int midGame,
      String midSport,
      int mgameDate,
      int mgameStamp,
      String mlocation,
      Team mawayTeam,
      Team mhomeTeam}) {
    this.idGame = midGame;
    this.idSport = midSport;
    this.gameDate = mgameDate;
    this.gameStamp = mgameStamp;
    this.location = mlocation;
    this.awayTeam = mawayTeam;
    this.homeTeam = mhomeTeam;
  }

  FixtureFireStore.fromJson(Map<String, dynamic> json) {
    print('$json');

    this.idGame = json['idGame'];
    this.idSport = json['idSport'];
    this.gameDate = json['gameDate'];
    this.gameStamp = json['gameTimestamp'];
    this.location = json['location'];
    this.awayTeam = json['awayTeam'];
    this.homeTeam = json['homeTeam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['idGame'] = this.idGame;
    data['idSport'] = this.idSport;
    data['gameDate'] = this.gameDate;
    data['gameTimestamp'] = this.gameStamp;
    data['location'] = this.location;
    data['awayTeam'] = this.awayTeam.toJson();
    data['homeTeam'] = this.homeTeam.toJson();

    return data;
  }
}
