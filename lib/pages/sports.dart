import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import '../widgets/list_games.dart';

class Sports extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SportsState();
  }
}

class _SportsState extends State<Sports> {
  String _dropdownValue;
  DateTime now = DateTime.now();
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
     _selectedDate =  DateTime(now.year, now.month, now.day);
  }


  Future<Null> _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: new DateTime.now().subtract(Duration(days: 3)),
        lastDate: new DateTime.now().add(Duration(days: 3)));
    if (picked != null && picked != _selectedDate)
      setState(() => _selectedDate = picked);
  }

  Widget rowFilters(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        DropdownButton<String>(
          style: Theme.of(context).textTheme.body2,
          value: _dropdownValue,
          hint: Text('<Seleccionar>'),
          onChanged: (String newValue) {
            setState(() {
              _dropdownValue = newValue;
            });
          },
          items: <String>['NBA', 'NHL', 'MLB', 'NFL']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        RaisedButton(
          //elevation: 0.0,
          onPressed: () => _selectDate(context),
          color: Theme.of(context).accentColor,
          child: Text(
            _formatoFecha(),
            style: Theme.of(context).textTheme.button,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(17.0),
          ),
        ),
      ],
    );
  }

  String _formatoFecha() {
     DateTime hoy = DateTime(now.year, now.month, now.day);
     DateTime ayer = DateTime(now.year, now.month, now.day-1);
     DateTime manana = DateTime(now.year, now.month, now.day+1);

    if (_selectedDate == hoy) {
      return 'HOY';
    } else if (_selectedDate == manana) {
      return 'MAÑANA';
    } else if (_selectedDate == ayer) {
      return 'AYER';
    } else {
      return formatDate(_selectedDate, [yyyy, '-', mm, '-', dd]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        rowFilters(context),
        Divider(),
        Expanded(
          child: ListGames(),
        )
      ],
    );
  }
}
