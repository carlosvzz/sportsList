import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/helpers/rutinas.dart' as rutinas;
import 'package:sports_list/helpers/rutinas.dart';
import 'package:sports_list/models/custom_date.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/services/firestore_service.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/models/fixture_firestore.dart';
import 'package:sports_list/models/fixture_sportsfeed.dart';
import 'package:sports_list/internals/keys.dart' as keys;

class GameModel with ChangeNotifier {
  CustomMenu selectedSport = new CustomMenu(kSportVacio, Icons.stars);
  CustomDate selectedDate = new CustomDate(DateTime.now());
  List<Game> listaOrig = [];

  bool isLoading = false;
  bool isFiltering = false;
  bool isDeleting = false;
  FirestoreService<Game> db = new FirestoreService<Game>('games');

  String get idSport => selectedSport.nombre;
  DateTime get idDate => selectedDate.date;

  Future<Null> setSelectedSport(String nombre, IconData icono) async {
    isLoading = true;
    print('paso por aqui>>1A $isLoading');
    notifyListeners();

    selectedSport = new CustomMenu(nombre, icono);
    await fetchGames();

    print('paso por aqui>>1B $isLoading');
    isLoading = false;
    notifyListeners();
  }

  Future<Null> setSelectedDate(DateTime date) async {
    isLoading = true;
    print('paso por aqui>>2A $isLoading');
    notifyListeners();

    selectedDate.date = date;
    await fetchGames();

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

  Future<void> deleteCollection(bool onlyToday) async {
    String _actualSport = idSport;
    try {
      Firestore.instance
          .collection("games")
          .getDocuments()
          .then((snapshot) async {
        DateTime _now = DateTime.now();
        DateTime _today = DateTime(_now.year, _now.month, _now.day);

        for (DocumentSnapshot ds in snapshot.documents) {
          DateTime _docDate = ds.data['date'].toDate();

          if (onlyToday == true) {
            // Borrar solo si es Hoy y para el Deporte mencionado
            if (_docDate == _today && ds.data['idSport'] == _actualSport) {
              await ds.reference.delete();
            }
          } else {
// Borrar solo si es antes de Hoy
            if (_docDate.isBefore(_today)) {
              await ds.reference.delete();
            }
          }
        }
      });
    } catch (e) {
      print('ERROR deleteCollection > ${e.toString()}');
    } finally {
      listaOrig = [];
      await setSelectedSport(kSportVacio, Icons.star);
    }
  }

  Future<void> setContadores(
      String idFireStore, String typeCount, int value) async {
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

        //Actualizar db
        await db.updateObject(listaOrig[index]);
        setColores(idFireStore, typeCount);
      }
    } catch (e) {
      print('ERR setContadores > ${e.toString()}');
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
        notifyListeners();
      }
    } catch (e) {
      print('ERR setColores > ${e.toString()}');
    }
  }

  //para deportes USA > NFL, NHL, NBA, MLB
  Future<dynamic> _getFixturesSportsFeed() async {
    String _username = keys.SportsFeedApi;
    String _password = keys.SportsFeedPwd;
    String _basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));

    try {
      String miUrl =
          '${keys.SportsFeedUrl}/$idSport/current/daily_game_schedule.json?fordate=' +
              formatDate(idDate, [yyyy, mm, dd]);

      http.Response response = await http.get(miUrl,
          headers: {'Authorization': _basicAuth}).catchError((error) {
        print('ERR _getFixturesSportsFeed > ${error.toString()}');
        throw Exception('No se pudo obtener los datos del feed. $error');
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
      print('ERR _getFixturesSportsFeed > ${e.toString()}');
    }
  }

  // para deportes Soccer
  Future<List<FixtureFireStore>> _getFixturesFirestore() async {
    List<FixtureFireStore> list = new List();

    try {
      List<DocumentSnapshot> templist;
      List<DateTime> dateFilter = rutinas.getSportDates(idSport, idDate);

      // gameDate en FS es entero con formato yyyymmdd
      String dateIni = formatDate(dateFilter[0], ['yyyy', 'mm', 'dd']);
      String dateFin = formatDate(dateFilter[1], ['yyyy', 'mm', 'dd']);

      CollectionReference collectionRef =
          Firestore.instance.collection("fixtures");
      QuerySnapshot collectionSnapshot = await collectionRef
          .where('idSport', isEqualTo: idSport)
          .where('gameDate', isGreaterThanOrEqualTo: int.parse(dateIni))
          .where('gameDate', isLessThanOrEqualTo: int.parse(dateFin))
          .orderBy('gameDate')
          .orderBy('gameTimestamp')
          .getDocuments();

      templist = collectionSnapshot.documents;
      list = templist.map((DocumentSnapshot docSnapshot) {
        return new FixtureFireStore.fromJson(docSnapshot.data);
      }).toList();
    } catch (e) {
      print('ERR _getFixturesFirestore > ${e.toString()}');
      throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
    }

    return list;
  }

  // para obtener los juegos finales del FS
  Future<List<Game>> _getGamesFirestore() async {
    List<DocumentSnapshot> templist;
    List<Game> list = new List();
    List<DateTime> dateFilter = rutinas.getSportDates(idSport, idDate);

    try {
      CollectionReference collectionRef =
          Firestore.instance.collection("games");
      QuerySnapshot collectionSnapshot = await collectionRef
          .where('idSport', isEqualTo: idSport)
          .where('date', isGreaterThanOrEqualTo: dateFilter[0])
          .where('date', isLessThanOrEqualTo: dateFilter[1])
          .orderBy('date')
          .orderBy('time')
          .getDocuments();

      templist = collectionSnapshot.documents;

      list = templist.map((DocumentSnapshot docSnapshot) {
        return new Game.fromMap(docSnapshot.data);
      }).toList();
    } catch (e) {
      print('ERR _getGamesFirestore > ${e.toString()}');
      throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
    }

    return list;
  }

  // Buscar JUEGOS, ya sea de la lista Original en memoria, si no del FireStore, y  si no nuevos de SportsFeed/FS Fixtures
  Future<Null> fetchGames() async {
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
          //Buscar en firestore para ver si ya estan guardados como Games
          List<Game> listaDB;
          listaDB = await _getGamesFirestore();

          if (listaDB?.isNotEmpty ?? false) {
            //Encontro datos ya en DB firestore
            // Agregarlo a _gameList
            listaDB.forEach((game) {
              listaOrig.add(game);
              setColores(game.id, 'initial');
            });
          } else {
            // No se encontro datos en DB, buscarlo en sportsfeed
            List<Gameentry> lista;

            if (isSoccer) {
              List<FixtureFireStore> listaFS = await _getFixturesFirestore();
              if (listaFS == null) {
                lista = null;
              } else {
                lista = new List<Gameentry>();

                listaFS.forEach((ofix) {
                  lista.add(ofix.toGameentry());
                });
              }
            } else {
              //US games
              try {
                var dataFromResponse = await _getFixturesSportsFeed();
                lista = FixtureSportsFeed.fromJson(dataFromResponse)
                    .dailygameschedule
                    .gameentry;
              } catch (e) {}
            }

            //Agregar respuesta a lista final de games
            if (lista != null) {
              lista.forEach((game) async {
                String hora24;
                DateTime fechaFinal;
                // Convertir hora string a hora 24 (en deportes USA)
                if (isSoccer) {
                  fechaFinal = DateTime.parse(game.date);
                  hora24 = game.time;
                } else {
                  fechaFinal = idDate;
                  String horaGame = game.scheduleStatus == 'Normal'
                      ? game.time
                      : game.originalTime;
                  hora24 = rutinas.convertirHora24(horaGame);
                }

                Game newGame = new Game.fromValues(
                    idSport,
                    int.parse(game.iD),
                    fechaFinal,
                    hora24,
                    game.awayTeam,
                    game.homeTeam,
                    game.location);

                //debugPrint('${newGame.toMap()}');
                //Agregar a DB y lista local
                String newId = await db.createObject(newGame);
                newGame.id = newId;
                if (newId.isEmpty) {
                  print('ERR fetchGames > NO ID');
                }

                listaOrig.add(newGame);
                setColores(newId, 'initial');
              });
            }
          }
        }
      }
    } catch (e) {
      print('ERR fetchGames > ${e.toString()}');
    }
  }
}
