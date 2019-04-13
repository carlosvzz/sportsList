import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class DateData {
  DateTime date;
  String formatDate;
  IconData icon;

  DateData(this.date, this.formatDate, this.icon);
}

class CustomDate {
  DateTime _today;  //Solo Fecha  

  CustomDate() {
      DateTime _now = DateTime.now();  
      _today =  DateTime(_now.year, _now.month, _now.day);    // Solo fecha
  }  
  
  DateTime get today {
    return _today;
  }

  List<DateData> listWeek() {    
    DateTime _dateAux = DateTime(_today.year, _today.month, _today.day- 2);
    List<DateData> _listData;
    DateData dateData;

    for (var i = 0; i < 7; i++) {
      

    }
    
    List<DateData> _listData = [
    new DateData('Liga MX', Icons.ac_unit),
    new DateData('MLB', Icons.backspace),
    new DateData('NBA', Icons.cached),
    new DateData('NHL', Icons.dashboard),
    new DateData('NFL', Icons.edit),
  ];

  return _listData;    
  }

  String formatName(DateTime date) {
     DateTime _yesterday = DateTime(_today.year, _today.month, _today.day-1);
     DateTime _tomorrow = DateTime(_today.year, _today.month, _today.day+1);

    if (date == _today) {
      return 'HOY';
    } else if (date == _tomorrow) {
      return 'MAÑANA';
    } else if (date == _yesterday) {
      return 'AYER';
    } else {
      return formatDate(date, [yyyy, '-', mm, '-', dd]);
    }
  }

  

}