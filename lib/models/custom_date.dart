import 'package:sports_list/helpers/format_date.dart';

class CustomDate {
  DateTime date;
  //
  DateTime _now;
  DateTime _today;
  DateTime _yesterday;
  DateTime _tomorrow;

  CustomDate(this.date) {
    initDates();

    date = DateTime(date.year, date.month, date.day); // Solo fecha
  }

  String get label => _formatName();
  String get getLabel => _formatNameSoloFecha();
  DateTime get getToday => _today;

  void initDates() {
    _now = DateTime.now();
    _today = DateTime(_now.year, _now.month, _now.day);
    _yesterday = DateTime(_today.year, _today.month, _today.day - 1);
    _tomorrow = DateTime(_today.year, _today.month, _today.day + 1);
  }

  String _formatName() {
    if (date == _today) {
      return 'HOY';
    } else if (date == _tomorrow) {
      return 'MAÑANA';
    } else if (date == _yesterday) {
      return 'AYER';
    } else {
      return formatDate(date, [D, ' ', dd, '/', mm]);
    }
  }

  String _formatNameSoloFecha() {
    // if (date == _today) {
    //   return 'HOY';
    // } else if (date == _tomorrow) {
    //   return 'MAÑANA';
    // } else if (date == _yesterday) {
    //   return 'AYER';
    // } else {
    return formatDate(date, [D, ' ', dd, '/', mm]);
    // }
  }
}
