import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';


class Sports extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SportsState();
  }
}

class _SportsState extends State<Sports> {
  String _dropdownValue;
  DateTime _selectedDate =DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: new DateTime.now().subtract(Duration(days: 3)),
        lastDate: new DateTime.now().add(Duration(days: 3)));
    if (picked != null && picked != _selectedDate) setState(() => _selectedDate = picked);
  }

  Widget comboPicker(BuildContext context) {
    return DropdownButton<String>(
      style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
             comboPicker(context),
           Text(formatDate(_selectedDate, [yyyy, '-', mm, '-', dd]), style: TextStyle(fontWeight: FontWeight.bold),),
           RaisedButton(onPressed: () => _selectDate(context), child: Text('Fecha'),)
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
