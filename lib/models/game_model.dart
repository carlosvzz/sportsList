import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:sports_list/services/firestore_service.dart';
import 'game.dart';
import 'package:sports_list/models/feed_games.dart';
import '../internals/keys.dart' as keys;

class GameScopedModel extends Model {
  List<Game> _gameList = [];
  bool isLoading = false;
  FirestoreService<Game> db = new FirestoreService<Game>('games');

  List<Game> getGameList(String idSport, DateTime date) {
    return _gameList
        .where((Game g) => g.idSport == idSport && g.date == date)
        .toList();
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

  void setContadores(String idFireStore, String typeCount, int value) {
    // Buscar index del Game
    int index = _gameList.indexWhere((Game g) => g.id == idFireStore);

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

  void setColores(String idFireStore, String typeCount) {
    // Buscar index del Game
    int index = _gameList.indexWhere((Game g) => g.id == idFireStore);

    // Colores
    if (typeCount == 'initial' ||
        typeCount == 'away' ||
        typeCount == 'home' ||
        typeCount == 'draw') {
      int valorMin = 999;
      int valorMax = -1;
      bool hayMax = false;
      Game game = _gameList[index];

      _gameList[index].colorAway = Colors.white;
      _gameList[index].colorDraw = Colors.white;
      _gameList[index].colorHome = Colors.white;

      // Valor maximo
      if (game.countAway > valorMax) valorMax = game.countAway;
      if (game.countDraw > valorMax) valorMax = game.countDraw;
      if (game.countHome > valorMax) valorMax = game.countHome;

      // Valor minimo
      if (game.countAway < valorMin) valorMin = game.countAway;
      if (game.countDraw < valorMin) valorMin = game.countDraw;
      if (game.countHome < valorMin) valorMin = game.countHome;

      // 3+ para ser verde
      if (game.countAway - game.countHome > 2 &&
          game.countAway - game.countDraw > 2) {
        hayMax = true;
        _gameList[index].colorAway = Colors.green;
      }

      if (game.countHome - game.countAway > 2 &&
          game.countHome - game.countDraw > 2) {
        hayMax = true;
        _gameList[index].colorHome = Colors.green;
      }

      if (game.countDraw - game.countAway > 2 &&
          game.countDraw - game.countHome > 2) {
        hayMax = true;
        _gameList[index].colorDraw = Colors.green;
      }

      ///////////////////////
      /// No se encontro un maximo. Poner verde al maximo y amarillo al segundo
      /// Solo en SOCCER
      if (game.idSport.toLowerCase().contains('soccer') && hayMax == false) {
        //// Maximo AWAY
        if (game.countAway == valorMax) {
          _gameList[index].colorAway = Colors.green;

          //2do lugar
          if (game.countDraw == game.countAway)
            _gameList[index].colorDraw = Colors.green;

          if (game.countHome == game.countAway)
            _gameList[index].colorHome = Colors.green;

          if (game.countDraw < game.countAway &&
              game.countDraw == game.countHome) {
            _gameList[index].colorDraw = Colors.yellowAccent.shade400;
            _gameList[index].colorHome = Colors.yellowAccent.shade400;
          }

          if (game.countDraw < game.countAway &&
              game.countDraw > game.countHome) {
            _gameList[index].colorDraw = Colors.yellowAccent.shade400;
          }

          if (game.countHome < game.countAway &&
              game.countHome > game.countDraw) {
            _gameList[index].colorHome = Colors.yellowAccent.shade400;
          }
        }

        //// MAXIMO DRAW
        if (game.countDraw == valorMax) {
          _gameList[index].colorDraw = Colors.green;

          //2do lugar
          if (game.countHome == game.countDraw)
            _gameList[index].colorHome = Colors.green;

          if (game.countAway < game.countDraw &&
              game.countAway == game.countHome) {
            _gameList[index].colorAway = Colors.yellowAccent.shade400;
            _gameList[index].colorHome = Colors.yellowAccent.shade400;
          }

          if (game.countAway < game.countDraw &&
              game.countAway > game.countHome) {
            _gameList[index].colorAway = Colors.yellowAccent.shade400;
          }

          if (game.countHome < game.countDraw &&
              game.countHome > game.countAway) {
            _gameList[index].colorHome = Colors.yellowAccent.shade400;
          }
        }

        //// MAXIMO HOME
        if (game.countHome == valorMax) {
          _gameList[index].colorHome = Colors.green;

          //2do lugar
          if (game.countAway < game.countHome &&
              game.countAway == game.countDraw) {
            _gameList[index].colorAway = Colors.yellowAccent.shade400;
            _gameList[index].colorDraw = Colors.yellowAccent.shade400;
          }

          if (game.countAway < game.countHome &&
              game.countAway > game.countDraw) {
            _gameList[index].colorAway = Colors.yellowAccent.shade400;
          }

          if (game.countDraw < game.countHome &&
              game.countDraw > game.countAway) {
            _gameList[index].colorDraw = Colors.yellowAccent.shade400;
          }
        }
      }
    }

    if (typeCount == 'initial' ||
        typeCount == 'overunder' ||
        typeCount == 'extra') {
      // 3+ Verde / -3 Rojo
      print('${_gameList[index].countOverUnder}');
      if (_gameList[index].countOverUnder > 2) {
        _gameList[index].colorOverUnder = Colors.green;
      } else if (_gameList[index].countOverUnder < -2) {
        _gameList[index].colorOverUnder = Colors.red.shade600;
      } else {
        _gameList[index].colorOverUnder = Colors.white;
      }

      if (_gameList[index].countExtra > 2) {
        _gameList[index].colorExtra = Colors.green;
      } else if (_gameList[index].countExtra < -2) {
        _gameList[index].colorExtra = Colors.red.shade600;
      } else {
        _gameList[index].colorExtra = Colors.white;
      }
    }

    notifyListeners();
  }

  Future<dynamic> _getGamesFeed(String idSport, DateTime date) async {
    String _username = keys.SportsFeedApi;
    String _password = keys.SportsFeedPwd;
    String _basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));

    String miUrl =
        '${keys.SportsFeedUrl}/$idSport/current/daily_game_schedule.json?fordate=' +
            formatDate(date, ['yyyy', 'mm', 'dd']);

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

  Future<List<Game>> _getGamesFirestore(String idSport, DateTime date) async {
    List<DocumentSnapshot> templist;
    List<Game> list = new List();

    CollectionReference collectionRef = Firestore.instance.collection("games");
    QuerySnapshot collectionSnapshot = await collectionRef
        .where('idSport', isEqualTo: idSport)
        .where('date', isEqualTo: date)
        .orderBy('time')
        .getDocuments();

    templist = collectionSnapshot.documents;

    list = templist.map((DocumentSnapshot docSnapshot) {
      //print('data -> ${docSnapshot.data}');
      return new Game.fromMap(docSnapshot.data);
    }).toList();

    return list;
  }

  String _addLeadingZero(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  String convertirHora24(String hora) {
    //hora viene como 7:00AM o 5:30PM
    final int pos = hora.indexOf(':');
    int parteHora = int.parse(hora.substring(0, pos));
    int parteMin = int.parse(hora.substring(pos + 1, pos + 3));

    //Convertir hora a 24 H (AM se queda igual)
    if (hora.contains('PM') == true) {
      if (parteHora < 12) parteHora += 12;
    }
    //Restar 1 hora para Central Time
    parteHora -= 1;

    String horaTexto = _addLeadingZero(parteHora);
    String minTexto = _addLeadingZero(parteMin);

    return horaTexto + ':' + minTexto;
  }

  Future fetchGames(String idSport, DateTime date) async {
    // Revisar si ya esta cargada la lista (deporte - fecha)
    var query;

    if (_gameList.length > 0) {
      query = _gameList.firstWhere(
          (Game g) => g.idSport == idSport && g.date == date,
          orElse: () => null);
    }
    if (query == null) {
      isLoading = true;
      notifyListeners();

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
        var dataFromResponse = await _getGamesFeed(idSport, date);

        List<Gameentry> lista =
            FeedGames.fromJson(dataFromResponse).dailygameschedule.gameentry;

        //Agregar respuesta a lista final de games
        if (lista != null) {
          lista.forEach((game) {
            // Convertir hora string a hora 24
            String horaGame =
                game.scheduleStatus == 'Normal' ? game.time : game.originalTime;
            String hora24 = convertirHora24(horaGame);

            Game newGame = new Game.fromValues(idSport, int.parse(game.iD),
                date, hora24, game.awayTeam, game.homeTeam, game.location);

            //Agregar a DB y lista local
            db.createObject(newGame);
            _gameList.add(newGame);
          });
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
