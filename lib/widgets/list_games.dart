import 'package:flutter/material.dart';
import 'package:sports_list/api/mysportsfeed.dart';
//import '../widgets/card_game.dart';
import 'package:http/http.dart' as http;

class ListGames extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListGamesState();
  }
}

class ListGamesState extends State<ListGames> {
  List items = getDummyList();
  Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchPosts(http.Client());
  }

  static List getDummyList() {
    List list = List.generate(10, (i) {
      return "Game ${i + 1}";
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");

          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  padding: const EdgeInsets.all(15.0),
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Divider(
                          height: 5.0,
                        ),
                        ListTile(
                            title: Text('${snapshot.data[index].title}'),
                            subtitle: Text('${snapshot.data[index].body}'),
                            onTap: () => {}),
                      ],
                    );
                  },
                )
              : CircularProgressIndicator();
        },
      ),
    );

    // return Container(
    //   child: ListView.builder(
    //     itemCount: items.length,
    //     itemBuilder: (context, index) {
    //       return CardGame(index, items[index]);
    //     },
    //   ),
    // );
  }
}
