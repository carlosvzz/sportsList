import 'dart:async';
import 'package:sports_list/models/game_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableGames = 'games';
  // Columns
  final String columnId = 'id';
  final String columnIdSport = 'title';
  final String columnIdGame = 'description';
  final String columnDate = 'date';
  final String columnTime = 'time';
  final String columnLocation = 'location';
  final String columnAwayTeamAbbrev = 'awayTeamAbbrev';
  final String columnAwayTeamName = 'awayTeamName';
  final String columnHomeTeamAbbrev = 'homeTeamAbbrev';
  final String columnHomeTeamName = 'homeTeamName';
  final String columnCountHome = 'countHome';
  final String columnCountAway = 'countAway';
  final String columnCountDraw = 'countDraw';
  final String columnCountOverUnder = 'countOverUnder'; // over / under
  final String columnCountExtra = 'countExtra'; // Extra s

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'xsports.db');

    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableGames($columnId TEXT PRIMARY KEY, $columnIdSport TEXT, $columnIdGame TEXT, $columnDate TEXT, $columnTime TEXT, $columnLocation TEXT, $columnAwayTeamAbbrev TEXT, $columnAwayTeamName TEXT, $columnHomeTeamAbbrev TEXT, $columnHomeTeamName TEXT, $columnCountHome INTEGER,  $columnCountAway INTEGER,  $columnCountDraw INTEGER,  $columnCountOverUnder INTEGER, $columnCountExtra INTEGER)');
  }

  Future<int> saveGame(GameDb game) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableGames, game.toMap());

    return result;
  }

  Future<List> getGames(String sport) async {
    var dbClient = await db;

    var result = await dbClient.query(tableGames,
        where: 'columnIdSport = ?', whereArgs: [sport], orderBy: 'date, time');
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote');

    return result.toList();
  }

  Future<int> deleteGame(String sport) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableGames, where: '$columnIdSport = ?', whereArgs: [sport]);
  }

  Future<int> updateGame(GameDb game) async {
    var dbClient = await db;
    return await dbClient.update(tableGames, game.toMap(),
        where: "$columnId = ?", whereArgs: [game.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
