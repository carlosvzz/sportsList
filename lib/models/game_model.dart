import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'game.dart';
import 'package:sports_list/models/feed_games.dart';
import '../internals/keys.dart' as keys;

class GameScopedModel extends Model {
  List<Game> _gameList = [];
  bool _isLoading = false;

  List<Game> get getGameList => _gameList;
  bool get isLoading => _isLoading;

  int getListCount() {
    return _gameList.length;
  }

  Game getGameByIndex(int index) {
    if (_gameList == null) {
      return null;
    }

    if (_gameList.length == 0) {
      return null;
    }

    return _gameList[index];
  }

  void setContadores(int index, String id, int value) {
    switch (id) {
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

    // Colores
    if (id == 'away' || id == 'home' || id == 'draw') {
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

  Future<dynamic> _getGames(String id, DateTime date) async {
    String _username = keys.SportsFeedApi;
    String _password = keys.SportsFeedPwd;
    String _basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));

    String miUrl =
        '${keys.SportsFeedUrl}/$id/current/daily_game_schedule.json?fordate=' +
            formatDate(date, ['yyyy', 'mm', 'dd']);

    http.Response response = await http
        .get(miUrl, headers: {'Authorization': _basicAuth}).catchError((error) {
      throw Exception('No se pudo obtener los datos del feed. $error');
    });

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception(
          'No se pudo obtener los datos del feed. ${response.statusCode.toString()} - ${response.reasonPhrase}');
    }
  }

  Future fetchGames(String id, DateTime date) async {
    _isLoading = true;
    _gameList = [];
    notifyListeners();

    var dataFromResponse = await _getGames(id, date);
    List<Gameentry> lista =
        FeedGames.fromJson(dataFromResponse).dailygameschedule.gameentry;

    //Agregar respuesta a lista final de games
    lista.forEach((game) {
      Game newGame = new Game(
        id: game.iD,
        date: game.date,
        time: game.time,
        scheduleStatus: game.scheduleStatus,
        originalTime: game.originalTime,
        location: game.location,
        homeTeam: game.homeTeam,
        awayTeam: game.awayTeam,
      );

      _gameList.add(newGame);
    });

    _isLoading = false;
    notifyListeners();
  }
}
