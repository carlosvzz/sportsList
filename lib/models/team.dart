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

  Team.fromJsonAPIFootball(Map json) {
    idTeam = json['team_id'].toString();
    name = json['team_name'];
    abbreviation = fnGetTeamAbbreviation(json['team_name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.idTeam;
    data['Name'] = this.name;
    data['Abbreviation'] = this.abbreviation;
    return data;
  }

  String fnGetTeamAbbreviation(String tName) {
    tName += "    "; //x si es menor a 3 caracteres
    String tAbbr = tName.substring(0, 4).toUpperCase();

    switch (tName.trim()) {
      // MLS
      case "New York City FC":
        tAbbr = "NYC";
        break;
      case "FC Dallas":
        tAbbr = "DAL";
        break;
      case "New England Revolution":
        tAbbr = "NE";
        break;
      case "Columbus Crew":
        tAbbr = "CLB";
        break;
      case "New York Red Bulls":
        tAbbr = "NYR";
        break;
      case "Real Salt Lake":
        tAbbr = "RSL";
        break;
      case "Los Angeles Galaxy":
        tAbbr = "LAG";
        break;
      case "San Jose Earthquakes":
        tAbbr = "SJ";
        break;
      case "FC Cincinnati":
        tAbbr = "CIN";
        break;
      case "DC United":
        tAbbr = "DC";
        break;
      case "Los Angeles FC":
        tAbbr = "LAF";
        break;
      case "Sporting Kansas City":
        tAbbr = "KC";
        break;

      //ENG - PREMIER
      case "West Ham":
        tAbbr = "HAM";
        break;
      case "Crystal Palace":
        tAbbr = "CPA";
        break;
      case "Manchester United":
        tAbbr = "MUN";
        break;

      ///ENG2 = CHAMPIONSHIP
      case "West Brom":
        tAbbr = "WEB";
        break;

      ///FRA
      case "Montpellier":
        tAbbr = "MTP";
        break;
      case "Paris Saint Germain":
        tAbbr = "PSG";
        break;
      case "Saint Etienne":
        tAbbr = "ETI";
        break;

      ///HOL
      case "De Graafschap":
        tAbbr = "GRF";
        break;
      case "FC OSS":
        tAbbr = "OSS";
        break;

      ///HOL2
      case "FC Eindhoven":
        tAbbr = "EIN";
        break;
      case "FC OSS":
        tAbbr = "OSS";
        break;
      case "FC Volendam":
        tAbbr = "VOL";
        break;
      case "Jong Ajax":
        tAbbr = "AJA";
        break;
      case "Jong AZ":
        tAbbr = "AZ ";
        break;
      case "Jong PSV":
        tAbbr = "PSV";
        break;
      case "Jong Utrecht":
        tAbbr = "UTR";
        break;

      ///MEX
      case "Atletico San Luis":
        tAbbr = "SLP";
        break;
      case "Club America":
        tAbbr = "AME";
        break;
      case "Club Queretaro":
        tAbbr = "QRO";
        break;
      case "Club Tijuana":
        tAbbr = "TIJ";
        break;
      case "FC Juarez":
        tAbbr = "JUA";
        break;
      case "Monarcas":
        tAbbr = "MOR";
        break;
      case "Monterrey":
        tAbbr = "MTY";
        break;
      case "U.N.A.M. - Pumas":
        tAbbr = "PUM";
        break;

      //ESPAÑA
      case "Atletico Madrid":
        tAbbr = "ATM";
        break;
      case "Real Betis":
        tAbbr = "BET";
        break;
      case "Real Madrid":
        tAbbr = "RMA";
        break;
      case "Real Sociedad":
        tAbbr = "SOC";
        break;
      case "Valladolid":
        tAbbr = "VAD";
        break;

      //Germany
      case "1899 Hoffenheim":
        tAbbr = "HOF";
        break;
      case "Bayer Leverkusen":
        tAbbr = "LEV";
        break;
      case "Bayern Munich":
        tAbbr = "MUN";
        break;
      case "Borussia Dortmund":
        tAbbr = "DOR";
        break;
      case "Borussia Monchengladbach":
        tAbbr = "BOR";
        break;
      case "Eintracht Frankfurt":
        tAbbr = "FRA";
        break;
      case "FC Augsburg":
        tAbbr = "AUG";
        break;
      case "FC Koln":
        tAbbr = "KOL";
        break;
      case "FC Schalke 04":
        tAbbr = "SCH";
        break;
      case "FSV Mainz 05":
        tAbbr = "MAI";
        break;
      case "Hertha Berlin":
        tAbbr = "HER";
        break;
      case "RB Leipzig":
        tAbbr = "RBL";
        break;
      case "SC Freiburg":
        tAbbr = "FRE";
        break;
      case "SC Paderborn 07":
        tAbbr = "PAD";
        break;
      case "Union Berlin":
        tAbbr = "BER";
        break;
      case "VfL Wolfsburg":
        tAbbr = "WOL";
        break;

      //Portugal
      case "FC Porto":
        tAbbr = "POR";
        break;
      case "Santa Clara":
        tAbbr = "SCL";
        break;
      case "SC Braga":
        tAbbr = "BRA";
        break;
    }

    return tAbbr;
  }
}
