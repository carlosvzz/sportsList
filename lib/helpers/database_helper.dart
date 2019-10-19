import 'dart:async';
import 'package:sports_list/models/game_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "Xsports.db";
  static final _databaseVersion = 1;
  static final String tableGames = 'games';
  // Columns
  final String columnId = 'id';
  final String columnIdSport = 'idSport';
  final String columnIdGame = 'idGame';
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

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int newVersion) async {
    await db.execute('''
        CREATE TABLE $tableGames(
          $columnId TEXT PRIMARY KEY, 
          $columnIdSport TEXT, 
          $columnIdGame TEXT, 
          $columnDate TEXT, 
          $columnTime TEXT, 
          $columnLocation TEXT, 
          $columnAwayTeamAbbrev TEXT, 
          $columnAwayTeamName TEXT, 
          $columnHomeTeamAbbrev TEXT, 
          $columnHomeTeamName TEXT, 
          $columnCountHome INTEGER,  
          $columnCountAway INTEGER,  
          $columnCountDraw INTEGER,  
          $columnCountOverUnder INTEGER, 
          $columnCountExtra INTEGER
        )''');
  }

  Future<int> saveGame(GameDb game) async {
    Database db = await instance.database;

    var result = await db.insert(tableGames, game.toMap());
    return result;
  }

  Future<List> getGames(String sport) async {
    Database db = await instance.database;

    var result = await db.query(tableGames,
        where: 'columnIdSport = ?', whereArgs: [sport], orderBy: 'date, time');
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote');

    return result.toList();
  }

  Future<int> deleteGame(String sport) async {
    Database db = await instance.database;

    return await db
        .delete(tableGames, where: '$columnIdSport = ?', whereArgs: [sport]);
  }

  Future<int> updateGame(GameDb game) async {
    Database db = await instance.database;

    return await db.update(tableGames, game.toMap(),
        where: "$columnId = ?", whereArgs: [game.id]);
  }

  Future close() async {
    return _database.close();
  }
}
