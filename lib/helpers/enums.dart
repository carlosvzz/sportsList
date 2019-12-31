enum TYPE_BET { ML, Spread, OverUnder, BTTS }
enum TYPE_SPORTS { SOCCER, NFL, NBA, NHL, MLB, NCAAF }
enum TIME_OF_DAY { All, Morning, Night }
enum ORDER_BY { MaxValue, DateTime, TypeBet, Sport, Draw, All }

String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, List<T> values) =>
    values.firstWhere((v) => key == enumToString(v), orElse: () => null);
