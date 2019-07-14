import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_list/providers/game_model.dart';
import 'package:sports_list/screens/my_modalbottom.dart';

class MyBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameModel oGame = Provider.of<GameModel>(context);

    void _showModalSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return MyModalBottom(oGame.setSelectedSport);
        },
      );
    }

    Future<Null> _selectDate(BuildContext context) async {
      DateTime _now = DateTime.now();
      DateTime _today = DateTime(_now.year, _now.month, _now.day);

      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: oGame.selectedDate.date,
        firstDate: _today.subtract(Duration(days: 1)),
        lastDate: _today.add(Duration(days: 10)),
        locale: const Locale("es", "ES"),
      );

      if (picked != null && picked != oGame.selectedDate.date) {
        oGame.selectedDate.date = picked;
      }
    }

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            child: Text('clear'),
            onPressed: () => oGame.setSelectedSport('X-Sports', Icons.star),
          ),
          RaisedButton(
            child: Text(
              '${oGame.selectedDate.label}',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () => _selectDate(context),
          ),
          RaisedButton(
            child: Text('sports'),
            onPressed: () {
              _showModalSheet(context);
            },
          ),
        ],
      ),
    );
  }
}
