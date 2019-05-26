import 'package:flutter/material.dart';
import 'package:sports_list/models/custom_date.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/screens/listGames/list_games.dart';

class MyBody extends StatelessWidget {
  final String _actualSport;
  final List<CustomDate> _listDates;
  final GameScopedModel _gameModel;
  
  MyBody(this._actualSport, this._listDates, this._gameModel);
  
  @override
  Widget build(BuildContext context) {
    return ListGames(_actualSport, _listDates[1].date, _gameModel);
    // return ListView(
    //             physics: NeverScrollableScrollPhysics(),
    //             children: _listDates
    //                 .map((data) =>
    //                     ListGames(_actualSport, data.date, _gameModel))
    //                 .toList(),
    //           );
  }
  
  
}