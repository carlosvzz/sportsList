import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/providers/game_model.dart';
import 'package:sports_list/screens/listGames/card_game.dart';
import 'package:sports_list/screens/listGames/card_game_soccer.dart';
// import 'package:sports_list/screens/listGames/list_games.dart';

class ContenedorJuegos extends StatefulWidget {
  @override
  _ContenedorJuegosState createState() => _ContenedorJuegosState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ContenedorJuegosState extends State<ContenedorJuegos> {
  final _debouncer = Debouncer(milliseconds: 200);
  TextEditingController _textController = new TextEditingController();
  String filtroEquipo;
  GameModel oGame;
  List<Game> _listaFiltrada;

  @override
  void initState() {
    super.initState();
    oGame = Provider.of<GameModel>(context, listen: false);
    filtroEquipo = '';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget mainWidget() {
    Widget content = Center(
      child: CircularProgressIndicator(),
    );

    _listaFiltrada = oGame.getListBySport();

    if (_listaFiltrada.length == 0) {
      content = Center(child: Text('NO GAMES...'));
    } else {
      content = ListView.builder(
        itemCount: _listaFiltrada.length,
        padding: const EdgeInsets.all(3.0),
        itemBuilder: (context, index) {
          bool siMostrar = false;

          if (filtroEquipo == null || filtroEquipo.isEmpty) {
            siMostrar = true;
          } else {
            if (_listaFiltrada[index]
                    .homeTeam
                    .abbreviation
                    .toLowerCase()
                    .startsWith(filtroEquipo.toLowerCase()) ||
                _listaFiltrada[index]
                    .awayTeam
                    .abbreviation
                    .toLowerCase()
                    .startsWith(filtroEquipo.toLowerCase())) {
              siMostrar = true;
            }
            //Buscar por nombre de equipo tambien (si no encontró abreviacion)
            if (!siMostrar) {
              // print('entro1');
              if (_listaFiltrada[index]
                      .homeTeam
                      .name
                      .toLowerCase()
                      .contains(filtroEquipo.toLowerCase()) ||
                  _listaFiltrada[index]
                      .awayTeam
                      .name
                      .toLowerCase()
                      .contains(filtroEquipo.toLowerCase())) {
                siMostrar = true;
              }
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
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          new Icon(
            Icons.search,
            color: _textController.text.length > 0
                ? Colors.lightBlueAccent
                : Colors.grey,
          ),
          new SizedBox(
            width: 10.0,
          ),
          new Expanded(
            child: new Stack(
                alignment: const Alignment(1.0, 1.0),
                children: <Widget>[
                  new TextField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0), hintText: 'Team'),
                    onChanged: (texto) {
                      if (texto == null || texto.isEmpty) {
                        setState(() {
                          filtroEquipo = '';
                        });
                      } else {
                        _debouncer.run(() {
                          // debugPrint('$texto y ${oGame.idSport}');
                          setState(() {
                            filtroEquipo = texto;
                          });
                        });
                      }
                    },
                    controller: _textController,
                  ),
                  _textController.text.length > 0
                      ? new IconButton(
                          icon: new Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              filtroEquipo = '';
                              _textController.clear();
                            });
                          })
                      : new Container(
                          height: 0.0,
                        )
                ]),
          ),
        ],
      ),
      SizedBox(
        height: 10.0,
      ),
      Flexible(
          child: (oGame.isLoading || oGame.isFiltering)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : mainWidget())
    ]);
  }
}
