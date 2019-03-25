import 'package:flutter/material.dart';
import '../widgets/card_game.dart';

class ListGames extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListGamesState();
  }
}

class ListGamesState extends State<ListGames> {
  List items = getDummyList();

  static List getDummyList() {
    List list = List.generate(10, (i) {
      return "Game ${i + 1}";
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return CardGame(index, items[index]);
        },
      ),
    );
  }
}
