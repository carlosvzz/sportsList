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
  //String filtroEquipo;
  GameModel oGame;
  List<Game> listaJuegos = List();
  List<Game> listaFiltrada = List();

  @override
  void initState() {
    super.initState();
    oGame = Provider.of<GameModel>(context, listen: false);
    // listaJuegos =
    //     oGame.listaOrig.where((Game g) => g.idSport == oGame.idSport).toList();

    listaJuegos = oGame.listaOrig;

    // listaJuegos =
    //     oGame.listaOrig.where((Game g) => g.idSport == oGame.idSport).toList();

    // setState(() {
    listaFiltrada = listaJuegos.toList();
    listaFiltrada =
        listaFiltrada.where((Game g) => g.idSport == oGame.idSport).toList();
    // });

    // listaFiltrada =
    //     oGame.listaOrig.where((Game g) => g.idSport == oGame.idSport).toList();
    // listBySport();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // listaFiltrada = listaJuegos;
    // setState(() {
    //   listaFiltrada =
    //       listaJuegos.where((Game g) => g.idSport == oGame.idSport).toList();
    // });

    return Column(
      children: <Widget>[
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
              child: new Stack(alignment: const Alignment(1.0, 1.0), children: <
                  Widget>[
                new TextField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0), hintText: 'Team'),
                  onChanged: (texto) {
                    if (texto == null || texto.isEmpty) {
                      setState(() {
                        listaFiltrada = listaJuegos
                            .where((Game g) => g.idSport == oGame.idSport)
                            .toList();
                      });
                    } else {
                      _debouncer.run(() {
                        debugPrint('$texto y ${oGame.idSport}');
                        setState(() {
                          listaFiltrada = listaJuegos
                              .where((u) => (u.idSport == oGame.idSport &&
                                  (u.awayTeam.abbreviation
                                          .toLowerCase()
                                          .startsWith(texto.toLowerCase()) ||
                                      u.homeTeam.abbreviation
                                          .toLowerCase()
                                          .startsWith(texto.toLowerCase()) ||
                                      u.awayTeam.name
                                          .toLowerCase()
                                          .contains(texto.toLowerCase()) ||
                                      u.homeTeam.name
                                          .toLowerCase()
                                          .contains(texto.toLowerCase()))))
                              .toList();

                          debugPrint(
                              'row > ${listaFiltrada.length.toString()}');
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
                            listaFiltrada = listaJuegos;
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
                : (listaFiltrada.length == 0)
                    ? Center(
                        child: Text('NO GAMES ... '),
                      )
                    : ListView.builder(
                        itemCount: listaFiltrada.length,
                        padding: const EdgeInsets.all(3.0),
                        itemBuilder: (context, index) {
                          if (listaFiltrada[index]
                              .idSport
                              .toUpperCase()
                              .contains('SOCCER')) {
                            return CardGameSoccer(listaFiltrada[index]);
                          } else {
                            return CardGame(listaFiltrada[index]);
                          }

                          // if (widget._filtroEquipo == null ||
                          //     widget._filtroEquipo.isEmpty) {
                          //   siMostrar = true;
                          // } else {
                          //   if (_listaFiltrada[index]
                          //           .homeTeam
                          //           .abbreviation
                          //           .toLowerCase()
                          //           .startsWith(widget._filtroEquipo
                          //               .toLowerCase()) ||
                          //       _listaFiltrada[index]
                          //           .awayTeam
                          //           .abbreviation
                          //           .toLowerCase()
                          //           .startsWith(widget._filtroEquipo
                          //               .toLowerCase())) {
                          //     siMostrar = true;
                          //   }
                          //   //Buscar por nombre de equipo tambien (si no encontró abreviacion)
                          //   if (!siMostrar) {
                          //     // print('entro1');
                          //     if (_listaFiltrada[index]
                          //             .homeTeam
                          //             .name
                          //             .toLowerCase()
                          //             .contains(widget._filtroEquipo
                          //                 .toLowerCase()) ||
                          //         _listaFiltrada[index]
                          //             .awayTeam
                          //             .name
                          //             .toLowerCase()
                          //             .contains(widget._filtroEquipo
                          //                 .toLowerCase())) {
                          //       siMostrar = true;
                          //     }
                          //   }
                          // }
                        },
                      )

            // : FutureBuilder<List<Game>>(
            //     future: oGame.getListaFiltrada(), // async work
            //     builder: (BuildContext context,
            //         AsyncSnapshot<List<Game>> snapshot) {
            //       switch (snapshot.connectionState) {
            //         case ConnectionState.waiting:
            //           return Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         default:
            //           if (snapshot.hasError)
            //             return new Text('Error: ${snapshot.error}');
            //           else
            //             listaFiltrada = snapshot.data;
            //           if (listaFiltrada.length == 0) {
            //             return Center(
            //               child: Text('NO GAMES ... '),
            //             );
            //           } else {
            //             return ListView.builder(
            //               itemCount: listaFiltrada.length,
            //               padding: const EdgeInsets.all(3.0),
            //               itemBuilder: (context, index) {
            //                 // bool siMostrar = false;
            //                 bool siMostrar = true;

            //                 // if (widget._filtroEquipo == null ||
            //                 //     widget._filtroEquipo.isEmpty) {
            //                 //   siMostrar = true;
            //                 // } else {
            //                 //   if (_listaFiltrada[index]
            //                 //           .homeTeam
            //                 //           .abbreviation
            //                 //           .toLowerCase()
            //                 //           .startsWith(widget._filtroEquipo
            //                 //               .toLowerCase()) ||
            //                 //       _listaFiltrada[index]
            //                 //           .awayTeam
            //                 //           .abbreviation
            //                 //           .toLowerCase()
            //                 //           .startsWith(widget._filtroEquipo
            //                 //               .toLowerCase())) {
            //                 //     siMostrar = true;
            //                 //   }
            //                 //   //Buscar por nombre de equipo tambien (si no encontró abreviacion)
            //                 //   if (!siMostrar) {
            //                 //     // print('entro1');
            //                 //     if (_listaFiltrada[index]
            //                 //             .homeTeam
            //                 //             .name
            //                 //             .toLowerCase()
            //                 //             .contains(widget._filtroEquipo
            //                 //                 .toLowerCase()) ||
            //                 //         _listaFiltrada[index]
            //                 //             .awayTeam
            //                 //             .name
            //                 //             .toLowerCase()
            //                 //             .contains(widget._filtroEquipo
            //                 //                 .toLowerCase())) {
            //                 //       siMostrar = true;
            //                 //     }
            //                 //   }
            //                 // }

            //                 if (siMostrar) {
            //                   if (listaFiltrada[index]
            //                       .idSport
            //                       .toUpperCase()
            //                       .contains('SOCCER')) {
            //                     return CardGameSoccer(listaFiltrada[index]);
            //                   } else {
            //                     return CardGame(listaFiltrada[index]);
            //                   }
            //                 } else {
            //                   return Container();
            //                 }
            //               },
            //             );
            //           }
            //       }
            //     },
            //   ),
            ),
      ],
    );
  }
}
