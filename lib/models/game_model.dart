import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/helpers/rutinas.dart' as rutinas;
import 'package:sports_list/services/firestore_service.dart';
import 'fixture_firestore.dart';
import 'game.dart';
import 'package:sports_list/models/fixture_sportsfeed.dart';
import '../internals/keys.dart' as keys;

class GameScopedModel extends Model {
  List<Game> _gameList = [];
  bool isLoading = false;
  FirestoreService<Game> db = new FirestoreService<Game>('games');

  List<Game> getGameList(String idSport, DateTime date) {
    List<DateTime> dateFilter = rutinas.getSportDates(idSport, date);
    //isLoading = true;
    //notifyListeners();

    List<Game> lista = _gameList
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

    //isLoading = false;
    //notifyListeners();

    return lista;
  }

  int getListCount(String idSport, DateTime date) {
    return _gameList
        .where((Game g) => g.idSport == idSport && g.date == date)
        .length;
  }

  Game getGameById(int idGame) {
    if (_gameList == null) {
      return null;
    }

    if (_gameList.length == 0) {
      return null;
    }

    return _gameList.singleWhere((Game g) => g.idGame == idGame);
  }

  Future deleteCollection(bool onlyToday, String idSport) async {
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
          if (_docDate == _today && ds.data['idSport'] == idSport) {
            //debugPrint('${ds.data['idSport']} y $idSport ');
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
    _gameList = [];
  }

  void setContadores(String idFireStore, String typeCount, int value) {
    // Buscar index del Game
    int index = _gameList.indexWhere((Game g) => g.id == idFireStore);

    if (index != null && index != -1) {
      switch (typeCount) {
        case 'away':
          _gameList[index].countAway = value;
          break;
        case 'home':
          _gameList[index].countHome = value;
          break;
        case 'draw':
          _gameList[index].countDraw = value;
          break;
        case 'overunder':
          _gameList[index].countOverUnder = value;
          break;
        case 'extra':
          _gameList[index].countExtra = value;
          break;
        default:
      }

      //Actualizar db
      db.updateObject(_gameList[index]);

      setColores(idFireStore, typeCount);
    }
  }

  void setColores(String idFireStore, String typeCount) {
    // Buscar index del Game
    int index = _gameList.indexWhere((Game g) => g.id == idFireStore);

    if (index != null && index != -1) {
      // Colores
      if (typeCount == 'initial' ||
          typeCount == 'away' ||
          typeCount == 'home' ||
          typeCount == 'draw') {
        int valorMax = -1;
        bool hayMax = false;
        Game game = _gameList[index];

        _gameList[index].colorAway = Colors.blueGrey.shade700;
        _gameList[index].colorDraw = Colors.blueGrey.shade700;
        _gameList[index].colorHome = Colors.blueGrey.shade700;

        // Valor maximo
        if (game.countAway > valorMax) valorMax = game.countAway;
        if (game.countDraw > valorMax) valorMax = game.countDraw;
        if (game.countHome > valorMax) valorMax = game.countHome;

        // 3+ que la suma del resto para ser verde
        if (game.countAway - (game.countHome + game.countDraw) > 2) {
          hayMax = true;
          _gameList[index].colorAway = Colors.green.shade600;
        }

        if (game.countHome - (game.countAway + game.countDraw) > 2) {
          hayMax = true;
          _gameList[index].colorHome = Colors.green.shade600;
        }

        if (game.countDraw - (game.countHome + game.countAway) > 2) {
          hayMax = true;
          _gameList[index].colorDraw = Colors.green.shade600;
        }

        ///////////////////////
        /// No se encontro un maximo. Poner amarillo  al maximo y rojo al segundo

        if (hayMax == false && valorMax > 0) {
          if (game.idSport.toLowerCase().contains('soccer') == false) {
            // Juegos USA , no hay empate, solo poner amarillo el mayor
            if (game.countAway == game.countHome) {
              _gameList[index].colorAway = Colors.yellowAccent.shade700;
              _gameList[index].colorHome = Colors.yellowAccent.shade700;
            } else if (game.countAway > game.countHome) {
              _gameList[index].colorAway = Colors.yellowAccent.shade700;
            } else {
              _gameList[index].colorHome = Colors.yellowAccent.shade700;
            }
          } else {
            // Juegos Soccer, considera EMPATE
            //// Maximo AWAY
            if (game.countAway == valorMax) {
              _gameList[index].colorAway = Colors.yellowAccent.shade700;

              //2do lugar
              if (game.countDraw == game.countAway)
                _gameList[index].colorDraw = Colors.yellowAccent.shade700;

              if (game.countHome == game.countAway)
                _gameList[index].colorHome = Colors.yellowAccent.shade700;

              if (game.countDraw < game.countAway &&
                  game.countDraw == game.countHome) {
                if (_gameList[index].countDraw > 0)
                  _gameList[index].colorDraw = Colors.red.shade600;
                if (_gameList[index].countHome > 0)
                  _gameList[index].colorHome = Colors.red.shade600;
              }

              if (game.countDraw < game.countAway &&
                  game.countDraw > game.countHome) {
                if (_gameList[index].countDraw > 0)
                  _gameList[index].colorDraw = Colors.red.shade600;
              }

              if (game.countHome < game.countAway &&
                  game.countHome > game.countDraw) {
                if (_gameList[index].countHome > 0)
                  _gameList[index].colorHome = Colors.red.shade600;
              }
            }

            //// MAXIMO DRAW
            if (game.countDraw == valorMax) {
              _gameList[index].colorDraw = Colors.yellowAccent.shade700;

              //2do lugar
              if (game.countHome == game.countDraw)
                _gameList[index].colorHome = Colors.yellowAccent.shade700;

              if (game.countAway < game.countDraw &&
                  game.countAway == game.countHome) {
                if (_gameList[index].countAway > 0)
                  _gameList[index].colorAway = Colors.red.shade600;
                if (_gameList[index].countHome > 0)
                  _gameList[index].colorHome = Colors.red.shade600;
              }

              if (game.countAway < game.countDraw &&
                  game.countAway > game.countHome) {
                if (_gameList[index].countAway > 0)
                  _gameList[index].colorAway = Colors.red.shade600;
              }

              if (game.countHome < game.countDraw &&
                  game.countHome > game.countAway) {
                if (_gameList[index].countHome > 0)
                  _gameList[index].colorHome = Colors.red.shade600;
              }
            }

            //// MAXIMO HOME
            if (game.countHome == valorMax) {
              _gameList[index].colorHome = Colors.yellowAccent.shade700;

              //2do lugar
              if (game.countAway < game.countHome &&
                  game.countAway == game.countDraw) {
                if (_gameList[index].countAway > 0)
                  _gameList[index].colorAway = Colors.red.shade600;
                if (_gameList[index].countDraw > 0)
                  _gameList[index].colorDraw = Colors.red.shade600;
              }

              if (game.countAway < game.countHome &&
                  game.countAway > game.countDraw) {
                if (_gameList[index].countAway > 0)
                  _gameList[index].colorAway = Colors.red.shade600;
              }

              if (game.countDraw < game.countHome &&
                  game.countDraw > game.countAway) {
                if (_gameList[index].countDraw > 0)
                  _gameList[index].colorDraw = Colors.red.shade600;
              }
            }
          }
        }
      }

      if (typeCount == 'initial' ||
          typeCount == 'overunder' ||
          typeCount == 'extra') {
        // 3+ Verde / -3 Rojo
        if (_gameList[index].countOverUnder > 2) {
          _gameList[index].colorOverUnder = Colors.green.shade600;
        } else if (_gameList[index].countOverUnder < -2) {
          _gameList[index].colorOverUnder = Colors.red.shade600;
        } else {
          _gameList[index].colorOverUnder = Colors.blueGrey.shade700;
        }

        if (_gameList[index].countExtra > 2) {
          _gameList[index].colorExtra = Colors.green.shade600;
        } else if (_gameList[index].countExtra < -2) {
          _gameList[index].colorExtra = Colors.red.shade800;
        } else {
          _gameList[index].colorExtra = Colors.blueGrey.shade700;
        }
      }

      notifyListeners();
    }
  }

  //para deportes USA > NFL, NHL, NBA, MLB
  Future<dynamic> _getFixturesSportsFeed(String idSport, DateTime date) async {
    String _username = keys.SportsFeedApi;
    String _password = keys.SportsFeedPwd;
    String _basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));

    String miUrl =
        '${keys.SportsFeedUrl}/$idSport/current/daily_game_schedule.json?fordate=' +
            formatDate(date, [yyyy, mm, dd]);

    http.Response response = await http
        .get(miUrl, headers: {'Authorization': _basicAuth}).catchError((error) {
      throw Exception('No se pudo obtener los datos del feed. $error');
    });

    if (response.statusCode == 200) {
      //print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception(
          'Datos no obtenidos. ${response.statusCode.toString()} - ${response.reasonPhrase}');
    }
  }

  // para deportes Soccer
  Future<List<FixtureFireStore>> _getFixturesFirestore(
      String idSport, DateTime date) async {
    List<DocumentSnapshot> templist;
    List<FixtureFireStore> list = new List();
    List<DateTime> dateFilter = rutinas.getSportDates(idSport, date);

    // gameDate en FS es entero con formato yyyymmdd
    String dateIni = formatDate(dateFilter[0], ['yyyy', 'mm', 'dd']);
    String dateFin = formatDate(dateFilter[1], ['yyyy', 'mm', 'dd']);

    try {
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
      throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
    }

    return list;
  }

  Future<List<Game>> _getGamesFirestore(String idSport, DateTime date) async {
    List<DocumentSnapshot> templist;
    List<Game> list = new List();
    List<DateTime> dateFilter = rutinas.getSportDates(idSport, date);

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
      throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
    }

    return list;
  }

  Future fetchGames(String idSport, DateTime date) async {
    bool isSoccer = idSport.toLowerCase().contains('soccer');
    List<DateTime> dateFilter = rutinas.getSportDates(idSport, date);

    // Revisar si ya esta cargada la lista (deporte - fecha)
    var query;
    isLoading = true;
    notifyListeners();

    if (_gameList.length > 0) {
      query = _gameList.firstWhere(
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
      listaDB = await _getGamesFirestore(idSport, date);

      if (listaDB != null && listaDB.length > 0) {
        //Encontro datos ya en DB firestore
        // Agregarlo a _gameList
        listaDB.forEach((game) {
          _gameList.add(game);
          setColores(game.id, 'initial');
        });
      } else {
        // No se encontro datos en DB, buscarlo en sportsfeed
        List<Gameentry> lista;

        if (isSoccer) {
          List<FixtureFireStore> listaFS =
              await _getFixturesFirestore(idSport, date);
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
          var dataFromResponse = await _getFixturesSportsFeed(idSport, date);
          lista = FixtureSportsFeed.fromJson(dataFromResponse)
              .dailygameschedule
              .gameentry;
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
              fechaFinal = date;
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
            _gameList.add(newGame);
            setColores(newId, 'initial');
          });
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
