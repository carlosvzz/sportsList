import 'dart:async';
import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/models/game.dart';
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
          $columnIdGame INTEGER, 
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

  Future<int> saveGame(Game oGame) async {
    Database db = await instance.database;

    var result = await db.insert(tableGames, oGame.toMapDatabase());
    return result;
  }

  Future<List<Game>> getGames(
      String sport, DateTime initDate, DateTime lastDate) async {
    Database db = await instance.database;
    List<Game> listaJuegos = new List();

    var result = await db.query(tableGames,
        where: '$columnIdSport = ? AND $columnDate >= ? AND $columnDate <= ?',
        whereArgs: [
          sport,
          formatDate(initDate, ['yyyy', '-', 'mm', '-', 'dd']),
          formatDate(lastDate, ['yyyy', '-', 'mm', '-', 'dd'])
        ],
        orderBy: '$columnDate, $columnTime');

    listaJuegos = result.map((Map<String, dynamic> data) {
      return new Game.fromMapDatabase(data);
    }).toList();

    return listaJuegos;
  }

  Future<int> deleteGameOld() async {
    Database db = await instance.database;

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    String todayFormat = formatDate(today, ['yyyy', '-', 'mm', '-', 'dd']);

    return await db
        .delete(tableGames, where: '$columnDate < ?', whereArgs: [todayFormat]);
  }

  Future<int> deleteGameBySport(String sport) async {
    Database db = await instance.database;

    return await db
        .delete(tableGames, where: '$columnIdSport = ?', whereArgs: [sport]);
  }

  Future<int> updateGame(Game oGame) async {
    Database db = await instance.database;

    return await db.update(tableGames, oGame.toMapDatabase(),
        where: "$columnId = ?", whereArgs: [oGame.id]);
  }

  Future close() async {
    return _database.close();
  }
}
