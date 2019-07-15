import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/providers/game_model.dart';
import 'package:sports_list/screens/listGames/card_game.dart';
import 'package:sports_list/screens/listGames/card_game_soccer.dart';

class ListGames extends StatefulWidget {
  final String _filtroEquipo;

  ListGames(this._filtroEquipo);

  @override
  _ListGamesState createState() => _ListGamesState();
}

class _ListGamesState extends State<ListGames> {
  GameModel oGame;

  @override
  void initState() {
    super.initState();
    oGame = Provider.of<GameModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    List<Game> _listaFiltrada;
    Widget content = Center(child: CircularProgressIndicator());

    if (oGame.isLoading || oGame.isFiltering) {
      content = Center(
        child: Text('FETCHING ... '),
      );
    } else {
      _listaFiltrada =
          Provider.of<GameModel>(context, listen: false).getListaFiltrada();
      if (_listaFiltrada.length == 0) {
        content = Center(
          child: Text('NO GAMES ... '),
        );
      } else {
        content = ListView.builder(
          itemCount: _listaFiltrada.length,
          padding: const EdgeInsets.all(3.0),
          itemBuilder: (context, index) {
            bool siMostrar = false;

            if (widget._filtroEquipo == null || widget._filtroEquipo.isEmpty) {
              siMostrar = true;
            } else {
              if (_listaFiltrada[index]
                      .homeTeam
                      .abbreviation
                      .toLowerCase()
                      .startsWith(widget._filtroEquipo.toLowerCase()) ||
                  _listaFiltrada[index]
                      .awayTeam
                      .abbreviation
                      .toLowerCase()
                      .startsWith(widget._filtroEquipo.toLowerCase())) {
                siMostrar = true;
              }
            }

            if (siMostrar) {
              if (_listaFiltrada[index]
                  .idSport
                  .toUpperCase()
                  .contains('SOCCER')) {
                return CardGameSoccer(_listaFiltrada[index]);
              } else {
                return CardGame(_listaFiltrada[index]);
              }
            } else {
              return Container();
            }
          },
        );
      }
    }
    return content;
  }
}
