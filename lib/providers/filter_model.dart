// import 'dart:convert';
import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queries/collections.dart';
import 'package:XSports/helpers/database_helper.dart';
import 'package:XSports/helpers/enums.dart';
import 'package:XSports/models/custom_date.dart';
import 'package:XSports/models/game.dart';
import 'package:XSports/models/game_bet.dart';

class FilterModel with ChangeNotifier {
  int numRegs;
  CustomDate dateIni;
  CustomDate dateFin;
  List<TYPE_SPORTS> filterSport;
  List<TYPE_BET> filterTypeBet;
  TIME_OF_DAY filterTimeofDay;
  ORDER_BY filterOrderBy;
  bool isLoading;
  List<GameBet> _listaBet;
  final dbHelper = DatabaseHelper.instance;

  FilterModel() {
    dateIni = new CustomDate(DateTime.now());
    dateFin = new CustomDate(DateTime.now());
    filterSport = [];
    filterTypeBet = [];
    filterTimeofDay = TIME_OF_DAY.All;
    filterOrderBy = ORDER_BY.MaxValue;
    isLoading = false;
  }

  Future<String> getGames() async {
    try {
//       CollectionReference collectionRef =
//           Firestore.instance.collection("games");

// // Obtener juegos con rango de fechas
//       QuerySnapshot collection = await collectionRef
//           .where('date', isGreaterThanOrEqualTo: dateIni.date)
//           .where('date', isLessThanOrEqualTo: dateFin.date)
//           .orderBy('date')
//           .orderBy('time')
//           .getDocuments();

      List<Game> listaJuegos =
          await dbHelper.getGamesFilter(dateIni.date, dateFin.date);

//Filtrar lista
      Future<String> listaFiltrada = _filtrarLista(listaJuegos);

      return listaFiltrada;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<String> _filtrarLista(List<Game> documentos) async {
    List<GameBet> listaFiltrada = [];
    _listaBet = [];

    // Revisar juegos validos
    await Future.wait(documentos.map((doc) async {
      // Game game = Game.fromMap(doc.data);
      _revisarGame(doc);
    }));

    // Armar lista de string
    if (_listaBet != null) {
      // Ordenar segun opcion seleccionada

      switch (this.filterOrderBy) {
        case ORDER_BY.MaxValue:
          var query = Collection(_listaBet)
              .orderByDescending((f) => f.maxValue - f.minValue)
              .thenBy((f) => f.minValue);

          listaFiltrada = query.toList();
          break;

        case ORDER_BY.Draw:
          var query = Collection(_listaBet)
              .orderByDescending((f) => f.maxValue - f.minValue)
              .thenBy((f) => f.minValue)
              .take(20);

          listaFiltrada = query.toList();
          break;

        case ORDER_BY.DateTime:
          var query = Collection(_listaBet)
              .orderBy((f) => f.date)
              .thenBy((f) => f.time)
              .thenByDescending((f) => f.maxValue - f.minValue)
              .thenBy((f) => f.minValue);

          listaFiltrada = query.toList();
          break;

        case ORDER_BY.TypeBet:
          var query = Collection(_listaBet)
              .orderBy((f) => enumToString(f.typeBet))
              .thenByDescending((f) => f.maxValue - f.minValue)
              .thenBy((f) => f.minValue);
          listaFiltrada = query.toList();
          break;

        case ORDER_BY.Sport:
        case ORDER_BY.All:
          var query = Collection(_listaBet)
              .orderBy((f) => f.idSport)
              .thenByDescending((f) => f.maxValue - f.minValue)
              .thenBy((f) => f.minValue);

          listaFiltrada = query.toList();
          break;
      }
    }

    numRegs = listaFiltrada.length;
    String listaBet = this
        .filterTypeBet
        .map((i) {
          return enumToString(i);
        })
        .toList()
        .join(" , ");

    String listaSport = this
        .filterSport
        .map((i) {
          return enumToString(i);
        })
        .toList()
        .join(" , ");

    String encabezado;
    encabezado = '#Regs =' + numRegs.toString();
    encabezado +=
        '\nFecha = ${this.dateIni.getLabel} - ${this.dateFin.getLabel}';
    encabezado +=
        '\n Orden = ${enumToString(this.filterOrderBy)}, Time = ${enumToString(this.filterTimeofDay)}';
    encabezado +=
        '\n Bet Type = ${this.filterTypeBet.isEmpty ? "TODOS" : listaBet}';
    encabezado +=
        '\n Sports = ${this.filterSport.isEmpty ? "TODOS" : listaSport}';

    String detalle = '';
    String idSportAux = '';
    String idTypeBetAux = '';

    listaFiltrada.forEach((t) {
      if (this.filterOrderBy == ORDER_BY.TypeBet) {
        //Separar por Type Bet
        if (idTypeBetAux != enumToString(t.typeBet)) {
          idTypeBetAux = enumToString(t.typeBet);
          detalle += '${"*" * 12} $idTypeBetAux ${"*" * 12} \n';
        }
      } else if (this.filterOrderBy == ORDER_BY.Sport ||
          this.filterOrderBy == ORDER_BY.All) {
        // Separar por Deporte
        if (idSportAux != t.idSport) {
          idSportAux = t.idSport;
          detalle += '${"*" * 12} $idSportAux ${"*" * 12} \n';
        }
      }

      // Leyenda de bet
      detalle += t.label + '\n';
    });

    return encabezado + '\n\n' + detalle;
  }

  void _addGame(GameBet game) {
    _listaBet.add(game);
  }

  void _revisarGame(Game oGame) {
    String textoFinal;
    String datoJuego;
    String etiquetaJuego;
    bool esSoccer;
    bool hayDifWin;
    bool continua;
    int teamGanador;
    int maxValue;
    int minValue;

    //Revisar si cumple con Tiempo
    continua = true;
    if (this.filterTimeofDay == TIME_OF_DAY.Morning) {
      continua = (int.parse(oGame.time.substring(0, 2)) < 15);
    } else if (this.filterTimeofDay == TIME_OF_DAY.Night) {
      continua = (int.parse(oGame.time.substring(0, 2)) >= 15);
    }

    // Solo mostrar si es hora actual o futura (la pasada ya no se muestra)
    CustomDate _auxDate = CustomDate(DateTime.now());
    if (continua && oGame.date == _auxDate.getToday) {
      int horaActual = DateTime.now().hour;
      continua = (int.parse(oGame.time.substring(0, 2)) >= horaActual);
    }
    /////////////////////////

    // Revisar si cumple con el Deporte
    // Draw solo aplica para Soccer
    if (continua && this.filterSport.length > 0) {
      switch (oGame.idSport) {
        case 'NFL':
          continua = this.filterSport.contains(TYPE_SPORTS.NFL) &&
              this.filterOrderBy != ORDER_BY.Draw;
          break;
        case 'NCAAF':
          continua = this.filterSport.contains(TYPE_SPORTS.NCAAF) &&
              this.filterOrderBy != ORDER_BY.Draw;
          break;
        case 'NBA':
          continua = this.filterSport.contains(TYPE_SPORTS.NBA) &&
              this.filterOrderBy != ORDER_BY.Draw;
          break;
        case 'NHL':
          continua = this.filterSport.contains(TYPE_SPORTS.NHL) &&
              this.filterOrderBy != ORDER_BY.Draw;
          break;
        case 'MLB':
          continua = this.filterSport.contains(TYPE_SPORTS.MLB) &&
              this.filterOrderBy != ORDER_BY.Draw;
          break;
        default:
          //Soccer
          continua = this.filterSport.contains(TYPE_SPORTS.SOCCER);
      }
    }

    if (continua) {
      esSoccer = oGame.idSport.toLowerCase().contains('soccer');
      etiquetaJuego =
          esSoccer ? oGame.idSport.replaceAll('Soccer', 'FB') : oGame.idSport;
      if (etiquetaJuego.length > 8) {
        etiquetaJuego = etiquetaJuego.substring(0, 8).trim();
      }

      String teamAway = oGame.awayTeam.abbreviation.padRight(3);
      String teamHome = oGame.homeTeam.abbreviation.padRight(3);

      if (esSoccer) {
        datoJuego = '$etiquetaJuego ${oGame.time} $teamHome v $teamAway >';
      } else {
        // US Games
        datoJuego = '$etiquetaJuego ${oGame.time} $teamAway @ $teamHome >';
      }

      ///////////////////////// MAIN //////////////////////////////
      teamGanador = -1;
      hayDifWin = false;

      if (esSoccer) {
// Draw pondrá los empates (diferencia por lo menos de +2)
        if (this.filterOrderBy == ORDER_BY.Draw) {
          teamGanador = 0;
          maxValue = oGame.countDraw;
          minValue = oGame.countHome + oGame.countAway;

          hayDifWin =
              (oGame.countDraw > (oGame.countHome + oGame.countAway + 1));
        } else {
          // DIFERENCIA CON MAS DE +2 VOTOS VS EL RESTO
          // Gana visitante
          if (oGame.countAway > (oGame.countHome + oGame.countDraw + 1)) {
            teamGanador = 2;
            hayDifWin = true;
            maxValue = oGame.countAway;
            minValue = oGame.countHome + oGame.countDraw;
          }
          // Gana Local
          if (!hayDifWin &&
              (oGame.countHome > (oGame.countAway + oGame.countDraw + 1))) {
            teamGanador = 1;
            hayDifWin = true;
            maxValue = oGame.countHome;
            minValue = oGame.countAway + oGame.countDraw;
          }
          // EMPATE
          if (!hayDifWin &&
              (oGame.countDraw > (oGame.countAway + oGame.countHome + 1))) {
            teamGanador = 0;
            hayDifWin = true;
            maxValue = oGame.countDraw;
            minValue = oGame.countHome + oGame.countAway;
          }
        }
      } else {
//US Games > Gana cualquiera  (visitante o local) con mínimo un +2
        // Visitante
        if (oGame.countAway > (oGame.countHome + 1)) {
          teamGanador = 2;
          hayDifWin = true;
          maxValue = oGame.countAway;
          minValue = oGame.countHome;
        }
        // Gana Local
        if (!hayDifWin && oGame.countHome > (oGame.countAway + 1)) {
          teamGanador = 1;
          hayDifWin = true;
          maxValue = oGame.countHome;
          minValue = oGame.countAway;
        }
      }

      if (filterOrderBy == ORDER_BY.All) {
        hayDifWin = true;
      }

      if (hayDifWin) {
        GameBet gameBet = new GameBet();
        gameBet.idSport = oGame.idSport;
        gameBet.date = oGame.date;
        gameBet.time = oGame.time;
        gameBet.maxValue = maxValue;
        gameBet.minValue = minValue;

        if (oGame.idSport.toLowerCase() == 'nba' ||
            oGame.idSport.toLowerCase() == 'nfl' ||
            oGame.idSport.toLowerCase() == 'ncaaf') {
          etiquetaJuego = 'sp+/-';
          gameBet.typeBet = TYPE_BET.Spread;
        } else {
          etiquetaJuego = 'ml';
          gameBet.typeBet = TYPE_BET.ML;
        }

        textoFinal = '$datoJuego $etiquetaJuego ';

        if (esSoccer) {
          switch (teamGanador) {
            case 0:
              textoFinal += "X";
              break;
            case 1:
              textoFinal += teamHome;
              break;
            case 2:
              textoFinal += teamAway;
              break;
            default:
          }
        } else {
          // US Games
          // Visitante
          if (teamGanador == 2) {
            textoFinal += teamAway;
          } else {
            textoFinal += teamHome;
          }
        }
        textoFinal += ' (${maxValue.toString()}.${minValue.toString()})';

        //Agregar a lista de bets
        if (filterOrderBy == ORDER_BY.All) {
          gameBet.label = datoJuego;
        } else {
          gameBet.label = textoFinal;
        }

        if (oGame.idSport.toLowerCase() == 'nba' ||
            oGame.idSport.toLowerCase() == 'nfl' ||
            oGame.idSport.toLowerCase() == 'ncaaf') {
          if (this.filterTypeBet.isEmpty ||
              this.filterTypeBet.contains(TYPE_BET.Spread)) {
            _addGame(gameBet);
          }
        } else {
          if (this.filterTypeBet.isEmpty ||
              this.filterTypeBet.contains(TYPE_BET.ML)) {
            _addGame(gameBet);
          }
        }
      }

      /////// OVER / UNDER ///////////////////////////////////////////////////////////////////////////
      ///// ALL no lo considera //////
      if (this.filterOrderBy != ORDER_BY.All && oGame.countOverUnder != 0) {
        GameBet gameBet = new GameBet();
        gameBet.idSport = oGame.idSport;
        gameBet.date = oGame.date;
        gameBet.time = oGame.time;
        gameBet.maxValue = oGame.countOverUnder.abs();
        gameBet.minValue = 0;

        gameBet.typeBet = TYPE_BET.OverUnder;

        textoFinal = datoJuego + ' ';
        textoFinal += (oGame.countOverUnder > 0) ? 'over' : 'under';
        textoFinal +=
            ' (${gameBet.maxValue.toString()}.${gameBet.minValue.toString()})';
        //Agregar a lista de bets
        gameBet.label = textoFinal;

        if (this.filterOrderBy != ORDER_BY.Draw &&
            (this.filterTypeBet.isEmpty ||
                this.filterTypeBet.contains(TYPE_BET.OverUnder))) {
          // Soccer solo agrega OVER (por lo menos 3)
          if (esSoccer) {
            if (oGame.countOverUnder > 2) _addGame(gameBet);
          } else {
            // Solo agrega si es mayor a +/- 1 (por lo menos 2)
            if (gameBet.maxValue > 1) _addGame(gameBet);
          }
        }
      }

      /////// EXTRA = ML (US) / BTTS (SOCCER) ///////////////////////////////////////////////////////////////////////////
      ///// ALL no lo considera //////
      if (this.filterOrderBy != ORDER_BY.All && oGame.countExtra != 0) {
        GameBet gameBet = new GameBet();
        gameBet.idSport = oGame.idSport;
        gameBet.date = oGame.date;
        gameBet.time = oGame.time;
        gameBet.maxValue = oGame.countExtra.abs();
        gameBet.minValue = 0;

        textoFinal = datoJuego + ' ';

        if (esSoccer) {
          gameBet.typeBet = TYPE_BET.BTTS;
          textoFinal += 'btts ';
          textoFinal += (oGame.countExtra > 0) ? 'Y' : 'N';
        } else {
          gameBet.typeBet = TYPE_BET.ML;
          textoFinal += 'ml ';
          textoFinal += (oGame.countExtra > 0) ? teamAway : teamHome;
        }

        textoFinal +=
            ' (${gameBet.maxValue.toString()}.${gameBet.minValue.toString()})';
        //Agregar a lista de bets
        gameBet.label = textoFinal;

// Solo agrega si es mayor a +/- 1 (por lo menos 2)
        if (this.filterOrderBy != ORDER_BY.Draw) {
          if (esSoccer) {
            if (this.filterTypeBet.isEmpty ||
                this.filterTypeBet.contains(TYPE_BET.BTTS)) {
              //Solo agrega BTTS Y (por lo menos 3)
              if (oGame.countExtra > 2) {
                _addGame(gameBet);
              }
            }
          } else {
            if (this.filterTypeBet.isEmpty ||
                this.filterTypeBet.contains(TYPE_BET.ML)) {
              if (gameBet.maxValue > 1) {
                _addGame(gameBet);
              }
            }
          }
        }
      }
    }
  }
}

class Games {}
