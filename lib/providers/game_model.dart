import 'dart:convert';
import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sports_list/helpers/database_helper.dart';
import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/helpers/rutinas.dart' as rutinas;
import 'package:sports_list/helpers/rutinas.dart';
import 'package:sports_list/models/custom_date.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/models/fixture_apifootball.dart';
import 'package:sports_list/models/fixtures_rundown.dart';
// import 'package:sports_list/services/firestore_service.dart';
import 'package:sports_list/models/game.dart';
//import 'package:sports_list/models/fixture_firestore.dart';
import 'package:sports_list/models/fixture_sportsfeed.dart';
import 'package:sports_list/internals/keys.dart' as keys;
import 'package:uuid/uuid.dart';

class GameModel with ChangeNotifier {
  CustomMenu selectedSport = new CustomMenu(kSportVacio, Icons.stars);
  CustomDate selectedDate = new CustomDate(DateTime.now());
  List<Game> listaOrig = [];

  bool isLoading = false;
  bool isFiltering = false;
  bool isDeleting = false;
  bool isUpdating = false;
  // FirestoreService<Game> db = new FirestoreService<Game>('games');
  final dbHelper = DatabaseHelper.instance;

  String get idSport => selectedSport.nombre;
  DateTime get idDate => selectedDate.date;

  Future<Null> setSelectedSport(String nombre, IconData icono) async {
    isLoading = true;
    notifyListeners();

    selectedSport = new CustomMenu(nombre, icono);
    await fetchGames();

    // print('paso por aqui>>1B $isLoading');
    isLoading = false;
    notifyListeners();
  }

  Future<Null> setSelectedDate(DateTime date) async {
    isLoading = true;
    //print('paso por aqui>>2A $isLoading');
    notifyListeners();

    selectedDate.date = date;
    fetchGames();

    isLoading = false;
    print('paso por aqui>>2C $isLoading');
    notifyListeners();
  }

  List<Game> getListaFiltrada() {
    List<DateTime> dateFilter = rutinas.getSportDates(idSport, idDate);

    List<Game> lista = listaOrig
        .where((Game g) =>
            g.idSport == idSport &&
            ((g.date.isAtSameMomentAs(dateFilter[0]) ||
                    g.date.isAfter(dateFilter[0])) &&
                (g.date.isAtSameMomentAs(dateFilter[1]) ||
                    g.date.isBefore(dateFilter[1]))))
        .toList();

    lista.sort((a, b) {
      var r = a.date.compareTo(b.date);
      if (r == 0) {
        return a.time.compareTo(b.time);
      } else {
        return r;
      }
    });

    isFiltering = false;
    return lista;
  }

  Future<void> deleteGames(bool onlySport) async {
    if (onlySport == true) {
      await dbHelper.deleteGameBySport(idSport);
      listaOrig.removeWhere((item) => item.idSport == idSport);
      //notifyListeners();
    } else {
      await dbHelper.deleteGameOld();
      listaOrig.clear();
      //notifyListeners();
    }
  }

  Future<void> setContadores(
      String idFireStore, String typeCount, int value) async {
    // isUpdating = true;
    // notifyListeners();

    try {
      // Buscar index del Game
      int index = listaOrig.indexWhere((Game g) => g.id == idFireStore);
      if (index != null && index != -1) {
        switch (typeCount) {
          case 'away':
            listaOrig[index].countAway = value;
            break;
          case 'home':
            listaOrig[index].countHome = value;
            break;
          case 'draw':
            listaOrig[index].countDraw = value;
            break;
          case 'overunder':
            listaOrig[index].countOverUnder = value;
            break;
          case 'extra':
            listaOrig[index].countExtra = value;
            break;
          default:
        }

        // Actualizar primero los colores para que se muestre sin "delay"
        setColores(idFireStore, typeCount);

        //Actualizar db
        await dbHelper.updateGame(listaOrig[index]);

        return Future.value(null);
      }
    } catch (e) {
      print('ERR setContadores > ${e.toString()}');
    } finally {
      // isUpdating = false;
      // notifyListeners();
    }
  }

  void setColores(String idFireStore, String typeCount) {
    try {
      // Buscar index del Game
      int index = listaOrig.indexWhere((Game g) => g.id == idFireStore);

      if (index != null && index != -1) {
        // Colores
        if (typeCount == 'initial' ||
            typeCount == 'away' ||
            typeCount == 'home' ||
            typeCount == 'draw') {
          int valorMax = -1;
          bool hayMax = false;
          Game game = listaOrig[index];

          listaOrig[index].colorAway = Colors.blueGrey.shade700;
          listaOrig[index].colorDraw = Colors.blueGrey.shade700;
          listaOrig[index].colorHome = Colors.blueGrey.shade700;

          // Valor maximo
          if (game.countAway > valorMax) valorMax = game.countAway;
          if (game.countDraw > valorMax) valorMax = game.countDraw;
          if (game.countHome > valorMax) valorMax = game.countHome;

          // 3+ que la suma del resto para ser verde
          if (game.countAway - (game.countHome + game.countDraw) > 2) {
            hayMax = true;
            listaOrig[index].colorAway = Colors.green.shade600;
          }

          if (game.countHome - (game.countAway + game.countDraw) > 2) {
            hayMax = true;
            listaOrig[index].colorHome = Colors.green.shade600;
          }

          if (game.countDraw - (game.countHome + game.countAway) > 2) {
            hayMax = true;
            listaOrig[index].colorDraw = Colors.green.shade600;
          }

          ///////////////////////
          /// No se encontro un maximo. Poner amarillo  al maximo y rojo al segundo

          if (hayMax == false && valorMax > 0) {
            if (game.idSport.toLowerCase().contains('soccer') == false) {
              // Juegos USA , no hay empate, solo poner amarillo el mayor
              if (game.countAway == game.countHome) {
                listaOrig[index].colorAway = Colors.yellowAccent.shade700;
                listaOrig[index].colorHome = Colors.yellowAccent.shade700;
              } else if (game.countAway > game.countHome) {
                listaOrig[index].colorAway = Colors.yellowAccent.shade700;
              } else {
                listaOrig[index].colorHome = Colors.yellowAccent.shade700;
              }
            } else {
              // Juegos Soccer, considera EMPATE
              //// Maximo AWAY
              if (game.countAway == valorMax) {
                listaOrig[index].colorAway = Colors.yellowAccent.shade700;

                //2do lugar
                if (game.countDraw == game.countAway)
                  listaOrig[index].colorDraw = Colors.yellowAccent.shade700;

                if (game.countHome == game.countAway)
                  listaOrig[index].colorHome = Colors.yellowAccent.shade700;

                if (game.countDraw < game.countAway &&
                    game.countDraw == game.countHome) {
                  if (listaOrig[index].countDraw > 0)
                    listaOrig[index].colorDraw = Colors.red.shade600;
                  if (listaOrig[index].countHome > 0)
                    listaOrig[index].colorHome = Colors.red.shade600;
                }

                if (game.countDraw < game.countAway &&
                    game.countDraw > game.countHome) {
                  if (listaOrig[index].countDraw > 0)
                    listaOrig[index].colorDraw = Colors.red.shade600;
                }

                if (game.countHome < game.countAway &&
                    game.countHome > game.countDraw) {
                  if (listaOrig[index].countHome > 0)
                    listaOrig[index].colorHome = Colors.red.shade600;
                }
              }

              //// MAXIMO DRAW
              if (game.countDraw == valorMax) {
                listaOrig[index].colorDraw = Colors.yellowAccent.shade700;

                //2do lugar
                if (game.countHome == game.countDraw)
                  listaOrig[index].colorHome = Colors.yellowAccent.shade700;

                if (game.countAway < game.countDraw &&
                    game.countAway == game.countHome) {
                  if (listaOrig[index].countAway > 0)
                    listaOrig[index].colorAway = Colors.red.shade600;
                  if (listaOrig[index].countHome > 0)
                    listaOrig[index].colorHome = Colors.red.shade600;
                }

                if (game.countAway < game.countDraw &&
                    game.countAway > game.countHome) {
                  if (listaOrig[index].countAway > 0)
                    listaOrig[index].colorAway = Colors.red.shade600;
                }

                if (game.countHome < game.countDraw &&
                    game.countHome > game.countAway) {
                  if (listaOrig[index].countHome > 0)
                    listaOrig[index].colorHome = Colors.red.shade600;
                }
              }

              //// MAXIMO HOME
              if (game.countHome == valorMax) {
                listaOrig[index].colorHome = Colors.yellowAccent.shade700;

                //2do lugar
                if (game.countAway < game.countHome &&
                    game.countAway == game.countDraw) {
                  if (listaOrig[index].countAway > 0)
                    listaOrig[index].colorAway = Colors.red.shade600;
                  if (listaOrig[index].countDraw > 0)
                    listaOrig[index].colorDraw = Colors.red.shade600;
                }

                if (game.countAway < game.countHome &&
                    game.countAway > game.countDraw) {
                  if (listaOrig[index].countAway > 0)
                    listaOrig[index].colorAway = Colors.red.shade600;
                }

                if (game.countDraw < game.countHome &&
                    game.countDraw > game.countAway) {
                  if (listaOrig[index].countDraw > 0)
                    listaOrig[index].colorDraw = Colors.red.shade600;
                }
              }
            }
          }
        }

        if (typeCount == 'initial' ||
            typeCount == 'overunder' ||
            typeCount == 'extra') {
          // 3+ Verde / -3 Rojo
          if (listaOrig[index].countOverUnder > 2) {
            listaOrig[index].colorOverUnder = Colors.green.shade600;
          } else if (listaOrig[index].countOverUnder < -2) {
            listaOrig[index].colorOverUnder = Colors.red.shade600;
          } else {
            listaOrig[index].colorOverUnder = Colors.blueGrey.shade700;
          }

          if (listaOrig[index].countExtra > 2) {
            listaOrig[index].colorExtra = Colors.green.shade600;
          } else if (listaOrig[index].countExtra < -2) {
            listaOrig[index].colorExtra = Colors.red.shade800;
          } else {
            listaOrig[index].colorExtra = Colors.blueGrey.shade700;
          }
        }
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('ERR setColores > ${e.toString()}');
    }
  }

  //para deportes USA > NFL, NHL, NBA, MLB
  Future<dynamic> _getFixturesSportsFeed(DateTime dateAux) async {
    String _username = keys.SportsFeedApi;
    String _password = keys.SportsFeedPwd;
    String _basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));

    String season = 'current';
    if (this.selectedSport.nombre == 'NFL') {
      season = '2019-regular';
    }

    try {
      String miUrl =
          '${keys.SportsFeedUrl}/$idSport/$season/daily_game_schedule.json?fordate=' +
              formatDate(dateAux, [yyyy, mm, dd]);

      //print(miUrl);
      http.Response response =
          await http.get(miUrl, headers: {'Authorization': _basicAuth});

      if (response.statusCode == 200) {
        //print(response.body);
        return json.decode(response.body);
      } else {
        print(
            'ERR _getFixturesSportsFeed > ${response.statusCode.toString()} - ${response.reasonPhrase}');
        throw Exception(
            'Datos no obtenidos. ${response.statusCode.toString()} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('ERR _getFixturesSportsFeed > ${e.toString()}');
      throw Exception('No se pudo obtener los datos del feed. $e');
    }
  }

  //para deportes USA > NCAF
  Future<dynamic> _getFixturesRunDown(DateTime dateAux) async {
    String idSport = '1'; //1 = NCAF
    try {
      // offset 300 es para Central Time (5 horas )
      String miUrl = '${keys.RunDownUrl}/sports/$idSport/events/' +
          formatDate(dateAux, [yyyy, '-', mm, '-', dd]) +
          '?offset=300';

      http.Response response = await http.get(miUrl, headers: {
        'x-rapidapi-host': keys.RunDownHost,
        'x-rapidapi-key': keys.RunDownApi
      });

      if (response.statusCode == 200) {
        //print(response.body);
        return json.decode(response.body);
      } else {
        print(
            'ERR _getFixturesSportsFeed > ${response.statusCode.toString()} - ${response.reasonPhrase}');
        throw Exception(
            'Datos no obtenidos. ${response.statusCode.toString()} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('ERR _getFixturesRunDown > ${e.toString()}');
      throw Exception('No se pudo obtener los datos del feed. $e');
    }
  }

  //para deportes Soccer
  Future<dynamic> _getFixturesApiFootball(DateTime dateAux) async {
    String idLeague = "";

    switch (idSport) {
      case 'Soccer ENG':
        idLeague = "524";
        break;
      case 'Soccer GER':
        idLeague = "754";
        break;
      case 'Soccer ESP':
        idLeague = "775";
        break;
      case 'Soccer ITA':
        idLeague = "891";
        break;
      case 'Soccer FRA':
        idLeague = "525";
        break;
      case 'Soccer HOL':
        idLeague = "566";
        break;
      case 'Soccer POR':
        idLeague = "766";
        break;
      case 'Soccer ENG2':
        idLeague = "565";
        break;
      case 'Soccer MLS':
        idLeague = "294";
        break;
      case 'Soccer MEX':
        idLeague = "584";
        break;
      case 'Soccer CHAMP':
        idLeague = "530";
        break;
      case 'Soccer EUR':
        idLeague = "514";
        break;
    }

    try {
      String miUrl = '${keys.ApiFootballUrl}/v2/fixtures/league/$idLeague/' +
          formatDate(dateAux, [yyyy, '-', mm, '-', dd]);

      http.Response response = await http.get(miUrl, headers: {
        'x-rapidapi-host': keys.ApiFootballHost,
        'x-rapidapi-key': keys.ApiFootballKey
      });

      if (response.statusCode == 200) {
        //print(response.body);
        return json.decode(response.body);
      } else {
        print(
            'ERR _getFixturesApiFootball > ${response.statusCode.toString()} - ${response.reasonPhrase}');
        throw Exception(
            'Datos no obtenidos. ${response.statusCode.toString()} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('ERR _getFixturesApiFootball > ${e.toString()}');
      throw Exception('No se pudo obtener los datos del feed. $e');
    }
  }

  // // para deportes Soccer
  // Future<List<FixtureFireStore>> _getFixturesFirestore() async {
  //   List<FixtureFireStore> list = new List();

  //   try {
  //     List<DocumentSnapshot> templist;
  //     List<DateTime> dateFilter = rutinas.getSportDates(idSport, idDate);

  //     // gameDate en FS es entero con formato yyyymmdd
  //     String dateIni = formatDate(dateFilter[0], ['yyyy', 'mm', 'dd']);
  //     String dateFin = formatDate(dateFilter[1], ['yyyy', 'mm', 'dd']);

  //     CollectionReference collectionRef =
  //         Firestore.instance.collection("fixtures");
  //     QuerySnapshot collectionSnapshot = await collectionRef
  //         .where('idSport', isEqualTo: idSport)
  //         .where('gameDate', isGreaterThanOrEqualTo: int.parse(dateIni))
  //         .where('gameDate', isLessThanOrEqualTo: int.parse(dateFin))
  //         .orderBy('gameDate')
  //         .orderBy('gameTimestamp')
  //         .getDocuments();

  //     templist = collectionSnapshot.documents;
  //     list = templist.map((DocumentSnapshot docSnapshot) {
  //       return new FixtureFireStore.fromJson(docSnapshot.data);
  //     }).toList();
  //   } catch (e) {
  //     print('ERR _getFixturesFirestore > ${e.toString()}');
  //     throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
  //   }

  //   return list;
  // }

  // para obtener los juegos finales del FS
  // Future<List<Game>> _getGamesFirestore() async {
  //   List<DocumentSnapshot> templist;
  //   List<Game> list = new List();
  //   List<DateTime> dateFilter = rutinas.getSportDates(idSport, idDate);

  //   try {
  //     CollectionReference collectionRef =
  //         Firestore.instance.collection("games");
  //     QuerySnapshot collectionSnapshot = await collectionRef
  //         .where('idSport', isEqualTo: idSport)
  //         .where('date', isGreaterThanOrEqualTo: dateFilter[0])
  //         .where('date', isLessThanOrEqualTo: dateFilter[1])
  //         .orderBy('date')
  //         .orderBy('time')
  //         .getDocuments();

  //     templist = collectionSnapshot.documents;

  //     list = templist.map((DocumentSnapshot docSnapshot) {
  //       return new Game.fromMap(docSnapshot.data);
  //     }).toList();
  //   } catch (e) {
  //     print('ERR _getGamesFirestore > ${e.toString()}');
  //     throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
  //   }

  //   return list;
  // }

  // Buscar JUEGOS, ya sea de la lista Original en memoria, si no del FireStore, y  si no nuevos de SportsFeed/FS Fixtures/RunDown/ApiFB
  Future<List<Game>> fetchGames() async {
    
    bool isSoccer = idSport.toLowerCase().contains('soccer');
    List<DateTime> dateFilter = rutinas.getSportDates(idSport, idDate);
    
    try {
      if (idSport.isNotEmpty && idSport != kSportVacio) {
        // Revisar si ya esta cargada la lista (deporte - fecha)
        var query;
        if (listaOrig.length > 0) {
          query = listaOrig.firstWhere(
              (Game g) =>
                  g.idSport == idSport &&
                  ((g.date.isAtSameMomentAs(dateFilter[0]) ||
                          g.date.isAfter(dateFilter[0])) &&
                      (g.date.isAtSameMomentAs(dateFilter[1]) ||
                          g.date.isBefore(dateFilter[1]))),
              orElse: () => null);
        }

        if (query == null) {
          // No esta cargado aun en la lista interna
          //Buscar en Database para ver si ya estan guardados como Games
          List<Game> listaDB;
          listaDB =
              await dbHelper.getGames(idSport, dateFilter[0], dateFilter[1]);

          if (listaDB?.isNotEmpty ?? false) {
            //Encontro datos ya en DB
            // Agregarlo a _gameList
            listaDB.forEach((game) {
              listaOrig.add(game);
              setColores(game.id, 'initial');
            });
          } else {
            // No se encontro datos en DB, buscarlo en sportsfeed/rundown/ApiFB
            List<Gameentry> lista;

            if (isSoccer) {
              //Soccer sera de Martes-Jueves o Viernes-Lunes, por lo que hay que recorrer el listado por cada día
              DateTime dateAux = dateFilter[0]; //Rango de inicio
              lista = new List<Gameentry>();

              while (dateAux.isBefore(dateFilter[1]) ||
                  dateAux.isAtSameMomentAs(dateFilter[1])) {
                try {
                  var dataFromResponse = await _getFixturesApiFootball(dateAux);
                  //print('dataFromResponse > $dataFromResponse');
                  FixturesApiFootball oFix =
                      FixturesApiFootball.fromJson(dataFromResponse);
                  if (oFix != null) {
                    if (oFix.api != null) {
                      if (oFix.api.results > 0) {
                        oFix.api.fixtures.forEach((f) {
                          lista.add(f.toGameentry());
                        });
                      }
                    }
                  }
                } catch (e) {
                  print('ERR fetchGames $e ');
                }

                //Aumentamos un día para traer partidos
                dateAux = dateAux.add(Duration(days: 1));
              }
            } else {
              //US games. NFL y NCAAF puede ser varíos días, por lo que hay que recorrer el listado por cada día
              DateTime dateAux = dateFilter[0]; //Rango de inicio
              lista = new List<Gameentry>();

              while (dateAux.isBefore(dateFilter[1]) ||
                  dateAux.isAtSameMomentAs(dateFilter[1])) {
                try {
                  if (idSport == 'NCAAF') {
                    var dataFromResponse = await _getFixturesRunDown(dateAux);

                    //print('dataFromResponse > $dataFromResponse');
                    FixturesRunDown oFix =
                        FixturesRunDown.fromJson(dataFromResponse);
                    oFix.events.forEach((f) {
                      lista.add(f.toGameentry());
                    });
                  } else {
                    var dataFromResponse =
                        await _getFixturesSportsFeed(dateAux);

                    //print('dataFromResponse > $dataFromResponse');
                    lista.addAll(FixtureSportsFeed.fromJson(dataFromResponse)
                        .dailygameschedule
                        .gameentry);
                  }
                } catch (e) {
                  print('ERR fetchGames $e ');
                }

                //Aumentamos un día para traer partidos
                dateAux = dateAux.add(Duration(days: 1));
              }
            }

            //Agregar respuesta a lista final de games
            if (lista != null) {
              Future.wait(lista.map((game) async {
                String hora24;
                DateTime fechaFinal = DateTime.parse(game.date);
                // Convertir hora string a hora 24 (en deportes USA)
                if (isSoccer) {
                  hora24 = game.time;
                } else {
                  if (idSport == 'NCAAF') {
                    hora24 = game.time; //NCAAF ya viene en formato 24
                  } else {
                    String horaGame = game.scheduleStatus == 'Normal'
                        ? game.time
                        : game.originalTime;
                    hora24 = rutinas.convertirHora24(horaGame);
                  }
                }

                Game newGame = new Game.fromValues(
                    idSport,
                    int.tryParse(game.iD) ?? 1,
                    fechaFinal,
                    hora24,
                    game.awayTeam,
                    game.homeTeam,
                    game.location);
                //Asignar id
                var uuid = new Uuid();
                String id = uuid.v1();
                newGame.id = id;

                // debugPrint('${newGame.toMap()}');
                //Agregar a DB y lista local
                int result = await dbHelper.saveGame(newGame);
                if (result == 0) {
                  listaOrig.add(newGame);
                  setColores(newGame.id, 'initial');
                }
              }));
            }
          }
        }
      }
    } catch (e) {
      print('ERR fetchGames > ${e.toString()}');
    }

    return getListaFiltrada();
  }
}
