import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class CustomDate {
  DateTime date;
  String label;
  IconData icon;
  //
  DateTime _now;
  DateTime _today;
  DateTime _yesterday;
  DateTime _tomorrow;

  CustomDate(this.date) {
    initDates();

    date = DateTime(date.year, date.month, date.day); // Solo fecha
    label = _formatName();
    icon = _customIcon();
  }

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
      return formatDate(date, [D , ' ', dd, '/', mm]);
    }
  }

  IconData _customIcon() {
    if (date == _today) {
      return Icons.today;
    } else if (date == _tomorrow || date == _yesterday) {
      return Icons.date_range;
    } else {
      return Icons.exit_to_app;
    }
  }
}
