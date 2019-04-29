import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/game.dart';
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
    widget.model.fetchGames(widget._actualSport, widget._selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    Widget modelBuilder = ScopedModelDescendant<GameScopedModel>(
      builder: (context, child, gameModel) {
        Widget content;
        if (gameModel.isLoading) {
          content = Center(child:CircularProgressIndicator());
        } else {
          List<Game> listaFiltrada =
              gameModel.getGameList(widget._actualSport, widget._selectedDate);

          if (listaFiltrada.length == 0) {
            content = Center(
              child: Text('NO GAMES!!'),
            );
          } else {
            content = ListView.builder(
              itemCount: listaFiltrada.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, index) {
                return CardGame(listaFiltrada[index], gameModel.setContadores);
              },
            );
          }
        }

        return content;
      },
    );

    return modelBuilder;
  }
}
