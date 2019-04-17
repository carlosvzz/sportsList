import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/screens/listGames/card_game.dart';

class ListGames extends StatefulWidget {
  ListGames(this._actualSport, this._selectedDate, this.model);
  final String _actualSport;
  final DateTime _selectedDate;
  final GameScopedModel model;

  @override
  _ListGamesState createState() => _ListGamesState();
}

class _ListGamesState extends State<ListGames> {
  @override
  void initState() {
    super.initState();
    if (widget._actualSport != 'X-Sports') {
      widget.model.fetchGames(widget._actualSport, widget._selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget modelBuilder = ScopedModelDescendant<GameScopedModel>(
      builder: (context, child, gameModel) {
        Widget content;

        if (gameModel.isLoading) {
          content = CircularProgressIndicator();
        } else if (gameModel.getListCount() == 0) {
          content = Center(
            child: Text('NO GAMES FOUND!!'),
          );
        } else {
          content = ListView.builder(
            itemCount: gameModel.getListCount(),
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, index) {
              return CardGame(index, gameModel.getGameByIndex(index),
                  gameModel.setContadores);
            },
          );
        }
        return content;
      },
    );

    return Center(
      child: (widget._actualSport == '' || widget._actualSport == 'X-Sports')
          ? Container()
          : modelBuilder,
    );
  }
}
