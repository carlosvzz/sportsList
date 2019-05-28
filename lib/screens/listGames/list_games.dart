import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/screens/listGames/card_game.dart';

class ListGames extends StatefulWidget {
  final String _sport;
  final DateTime _date;
  final GameScopedModel _model;

  ListGames(this._sport, this._date, this._model);
  
  @override
  _ListGamesState createState() => _ListGamesState();
}

class _ListGamesState extends State<ListGames> {
  @override
  void initState() {
    super.initState();   
    print('${widget._sport} y ${widget._date.toIso8601String()}');
    widget._model.fetchGames(widget._sport, widget._date);
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
              gameModel.getGameList(widget._sport, widget._date);

          if (listaFiltrada.length == 0) {
            content = Center(
              child: Text('NO GAMES!!'),
            );
          } else {
            content = ListView.builder(
              itemCount: listaFiltrada.length,
              padding: const EdgeInsets.all(3.0),
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
