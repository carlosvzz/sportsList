import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_list/helpers/rutinas.dart';
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

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            child: Text('clear'),
            onPressed: () => Provider.of<GameModel>(context)
                .setSelectedSport(kSportVacio, Icons.star),
          ),
          WidgetFecha(),
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

class WidgetFecha extends StatefulWidget {
  @override
  _WidgetFechaState createState() => _WidgetFechaState();
}

class _WidgetFechaState extends State<WidgetFecha> {
  Future<Null> _selectDate(BuildContext context, GameModel oGame) async {
    DateTime _now = DateTime.now();
    DateTime _today = DateTime(_now.year, _now.month, _now.day);

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: oGame.selectedDate.date,
      firstDate: _today.subtract(Duration(days: 1)),
      lastDate: _today.add(Duration(days: 15)),
      locale: const Locale("es", "ES"),
    );

    if (picked != null && picked != oGame.selectedDate.date) {
      oGame.setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, game, child) {
        return RaisedButton(
            child: Text(
              '${game.selectedDate.label}',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () async {
              await _selectDate(context, game);
            });
      },
    );
  }
}
