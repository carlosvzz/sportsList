import 'package:flutter/material.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/screens/listGames/list_games.dart';

class MyBody extends StatelessWidget {
  final String _sport;
  final DateTime _date;
  final GameScopedModel _gameModel;

  MyBody(this._sport, this._date, this._gameModel);
  
  @override
  Widget build(BuildContext context) {
    return ListGames(_sport, _date, _gameModel);
  }
  
  
}