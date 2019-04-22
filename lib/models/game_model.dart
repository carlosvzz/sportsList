import 'dart:convert';
import 'dart:async';
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
  bool _isLoading = false;
  FirestoreService<Game> db = new FirestoreService<Game>('games');

  bool get isLoading => _isLoading;

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
      case 'over':
        _gameList[index].countOver = value;
        break;
      case 'under':
        _gameList[index].countUnder = value;
        break;
      default:
    }

    //Actualizar db
     db.updateObject(_gameList[index]);


    // Colores
    if (typeCount == 'away' || typeCount == 'home' || typeCount == 'draw') {
      _gameList[index].colorAway =
          (_gameList[index].countAway > _gameList[index].countHome &&
                  _gameList[index].countAway > _gameList[index].countDraw)
              ? Colors.green
              : Colors.white;
      _gameList[index].colorHome =
          (_gameList[index].countHome > _gameList[index].countAway &&
                  _gameList[index].countHome > _gameList[index].countDraw)
              ? Colors.green
              : Colors.white;
      _gameList[index].colorDraw =
          (_gameList[index].countDraw > _gameList[index].countHome &&
                  _gameList[index].countDraw > _gameList[index].countAway)
              ? Colors.green
              : Colors.white;
    } else {
      _gameList[index].colorOver =
          (_gameList[index].countOver > _gameList[index].countUnder)
              ? Colors.green
              : Colors.white;
      _gameList[index].colorUnder =
          (_gameList[index].countUnder > _gameList[index].countOver)
              ? Colors.green
              : Colors.white;
    }

    notifyListeners();
  }

  Future<dynamic> _getGames(String idSport, DateTime date) async {
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
          'No se pudo obtener los datos del feed. ${response.statusCode.toString()} - ${response.reasonPhrase}');
    }
  }

  Future fetchGames(String idSport, DateTime date) async {
    // Revisar si ya esta cargada la lista (deporte - fecha)
    var query;

    if (_gameList.length > 0) {
      print('entro aqui $idSport = $date');
      query = _gameList.firstWhere(
          (Game g) => g.idSport == idSport && g.date == date,
          orElse: () => null);
    }
    if (query == null) {
      _isLoading = true;
      notifyListeners();

      var dataFromResponse = await _getGames(idSport, date);
      List<Gameentry> lista =
          FeedGames.fromJson(dataFromResponse).dailygameschedule.gameentry;

      //Agregar respuesta a lista final de games
      lista.forEach((game) {
        Game newGame = new Game.fromValues(
            idSport,
            int.parse(game.iD),
            date,
            game.scheduleStatus == 'Normal' ? game.time : game.originalTime,
            game.awayTeam,
            game.homeTeam,
            game.location);

        //Agregar a DB y lista local
        db.createObject(newGame);
        _gameList.add(newGame);

      });
    }

    _isLoading = false;
    notifyListeners();
  }
}
