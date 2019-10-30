import 'package:sports_list/helpers/enums.dart';

class GameBet {
  String idSport;
  DateTime date;
  String time; // formato 24H 00:00
  TYPE_BET typeBet;
  String label;
  int maxValue = 0;
  int minValue = 0;
}
