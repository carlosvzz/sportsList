import 'package:flutter/material.dart';
import 'package:sports_list/models/custom_date.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/screens/my_modalbottom.dart';

class MyBottomBar extends StatelessWidget {
  final Function fnSetSport;
  final Function fnSetDate;
  final CustomDate _selectedDate;

  MyBottomBar(this.fnSetSport, this.fnSetDate, this._selectedDate);

  @override
  Widget build(BuildContext context) {
      
      void _showModalSheet() {
    showModalBottomSheet(context: context, builder: (builder) {
          return MyModalBottom(fnSetSport);
  },);}

  Future<Null> _selectDate(BuildContext context) async { 
    DateTime _now = DateTime.now();
    DateTime _today = DateTime(_now.year, _now.month, _now.day);

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate.date,
        firstDate: _today.subtract(Duration(days: 1)),
        lastDate: _today.add(Duration(days: 7)),
        );
    
    if (picked != null && picked != _selectedDate.date) {
        fnSetDate(picked);
      }
  }

    return BottomAppBar(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
RaisedButton(child: Text('clear'), onPressed: () => fnSetSport(new CustomMenu('X-Sports', Icons.star)),),
RaisedButton(child: Text('${_selectedDate.label}', style: TextStyle(color: Theme.of(context).accentColor),), onPressed: () => _selectDate(context),),
RaisedButton(child: Text('sports'), onPressed: () {
_showModalSheet();
} ,),
        ],),);
  }
}