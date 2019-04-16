import 'package:flutter/material.dart';
import 'package:sports_list/api/mysportsfeed.dart';
import 'package:sports_list/models/feed_games.dart';
import 'package:sports_list/screens/listGames/card_game.dart';

class ListGames extends StatefulWidget {
  ListGames(this._actualSport, this._selectedDate);

  final String _actualSport;
  final DateTime _selectedDate;

  @override
  State<StatefulWidget> createState() {
    return ListGamesState();
  }
}

class ListGamesState extends State<ListGames>
    with AutomaticKeepAliveClientMixin<ListGames> {
  Future<List<Gameentry>> _games;

  @override
  bool get wantKeepAlive => true; // Para el AutomaticKeepAliveClientMixin

  @override
  void initState() {
    super.initState();
  
    if (widget._actualSport != '' && widget._actualSport != 'X-Sports') {
       print(widget._actualSport);
      _games =
          fetchGames(widget._actualSport.toLowerCase(), widget._selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // para el AutomaticKeepAliveClientMixin

    var futureBuilder = FutureBuilder<List<Gameentry>>(
      future: _games,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text("${snapshot.error}");

        return !snapshot.hasData
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: snapshot.data.length,
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (context, index) {
                  return CardGame(widget._selectedDate, snapshot.data[index]);
                },
              );
      },
    );
    
    return Center(
      child: (widget._actualSport == '' || widget._actualSport == 'X-Sports') ? Container() : futureBuilder,
    );

   
  }
}
