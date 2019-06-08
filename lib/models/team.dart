class Team {
  String idTeam;
  String name;
  String abbreviation;

  Team({String mIdTeam, String mName, String mAbbreviation}) {
    this.idTeam = mIdTeam;
    this.name = mName;
    this.abbreviation = mAbbreviation;
  }

  Team.fromJson(Map json) {
    idTeam = json['ID'];
    name = json['Name'];
    abbreviation = json['Abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.idTeam;
    data['Name'] = this.name;
    data['Abbreviation'] = this.abbreviation;
    return data;
  }
}
