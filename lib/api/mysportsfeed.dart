import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:sports_list/models/feed_games.dart';
import '../internals/keys.dart' as keys;

Future<List<Gameentry>> fetchGames(String id, DateTime date) async {
  ///String username = 'd9a32c89-be45-4a21-b331-6f0fe2';
  String username = keys.SportsFeedApi;
  String password = keys.SportsFeedPwd;
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  String miUrl =
      '${keys.SportsFeedUrl}/$id/current/daily_game_schedule.json?fordate=' +
          formatDate(date, ['yyyy', 'mm', 'dd']);

  http.Response response =
      await http.get(miUrl, headers: {'authorization': basicAuth});

  if (response.statusCode == 200) {
    //print(response.body);
    final responseJson = json.decode(response.body);
    return FeedGames.fromJson(responseJson).dailygameschedule.gameentry;
  } else {
    throw Exception(
        'No se pudo obtener los datos del feed. ${response.statusCode.toString()} - ${response.reasonPhrase}');
  }
}
