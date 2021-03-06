import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/screens/listGames/card_game.dart';
import 'package:sports_list/screens/listGames/card_game_soccer.dart';

class ListGames extends StatefulWidget {
  final String _sport;
  final DateTime _date;
  final String _filtroEquipo;

  ListGames(this._sport, this._date, this._filtroEquipo);

  @override
  _ListGamesState createState() => _ListGamesState();
}

class _ListGamesState extends State<ListGames> {
  @override
  Widget build(BuildContext context) {
    Widget modelBuilder = ScopedModelDescendant<GameScopedModel>(
      builder: (context, child, gameModel) {
        Widget content;
        if (gameModel.isLoading) {
          content = Center(child: CircularProgressIndicator());
        } else {
          List<Game> listaFiltrada =
              gameModel.getGameList(widget._sport, widget._date);

          if (listaFiltrada.length == 0) {
            content = Center(
              child: Text('NO GAMES / FETCHING ... '),
            );
          } else {
            content = ListView.builder(
              itemCount: listaFiltrada.length,
              padding: const EdgeInsets.all(3.0),
              itemBuilder: (context, index) {
                bool siMostrar = false;

                if (widget._filtroEquipo == null ||
                    widget._filtroEquipo.isEmpty) {
                  siMostrar = true;
                } else {
                  if (listaFiltrada[index]
                          .homeTeam
                          .abbreviation
                          .toLowerCase()
                          .contains(widget._filtroEquipo.toLowerCase()) ||
                      listaFiltrada[index]
                          .awayTeam
                          .abbreviation
                          .toLowerCase()
                          .contains(widget._filtroEquipo.toLowerCase())) {
                    siMostrar = true;
                    print('si entro =S');
                  }
                }

                if (siMostrar) {
                  if (listaFiltrada[index]
                      .idSport
                      .toUpperCase()
                      .contains('SOCCER')) {
                    return CardGameSoccer(
                        listaFiltrada[index], gameModel.setContadores);
                  } else {
                    return CardGame(
                        listaFiltrada[index], gameModel.setContadores);
                  }
                } else {
                  return Container();
                }
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
