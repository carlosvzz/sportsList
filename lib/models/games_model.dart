import 'games.dart';
import 'package:scoped_model/scoped_model.dart';

class GamesModel extends Model {
  List<Game> _games = [];
  String _selGameId;
  bool _isLoading = false;

  List<Game> get allGames {
    return List.from(_games);
  }

  void selectGame(String gameId) {
    _selGameId = gameId;
    if (gameId != null) {
      notifyListeners();
    }
  }

  int get selectedGameIndex {
    return _games.indexWhere((Game g) => g.id == _selGameId);
  }

  String get selectedGameId {
    return _selGameId;
  }

  Game get selectedGame {
    if (_selGameId == null) {
      return null;
    }
    return _games.firstWhere((Game g) => g.id ==_selGameId);
  }

  
}
