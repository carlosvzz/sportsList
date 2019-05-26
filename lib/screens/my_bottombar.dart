import 'package:flutter/material.dart';
import 'package:sports_list/models/custom_date.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/screens/my_modalbottom.dart';

class MyBottomBar extends StatelessWidget {
  final Function setSport;
  final Function setDate;
  final CustomDate _selectedDate;

  MyBottomBar(this.setSport, this.setDate, this._selectedDate);

  @override
  Widget build(BuildContext context) {
      
      void _showModalSheet() {
    showModalBottomSheet(context: context, builder: (builder) {
          return MyModalBottom(setSport);
  },);}

  
    return BottomAppBar(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
RaisedButton(child: Text('clear'), onPressed: () => setSport(new CustomMenu('X-Sports', Icons.star)),),
RaisedButton(child: Text('${_selectedDate.label}', style: TextStyle(color: Theme.of(context).accentColor),), onPressed: () => setSport(new CustomMenu('X-Sports', Icons.star)),),
RaisedButton(child: Text('sports'), onPressed: () {
_showModalSheet();
} ,),
        ],),);
  }
}