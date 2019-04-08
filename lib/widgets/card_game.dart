import 'package:flutter/material.dart';

class CardGame extends StatefulWidget {
  final int index;
  final String title;

  CardGame(this.index, this.title);

  @override
  State<StatefulWidget> createState() {
    return CardGameState();
  }
}

class CardGameState extends State<CardGame> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              height: 100.0,
              width: 70.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://tsnimages.tsn.ca/ImageProvider/TeamLogo?seoId=san-antonio-spurs&width=128&height=128"))),
            ),
            Expanded(
              child: Container(
                //height: 100,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            '2',
                            style: Theme.of(context).textTheme.headline,
                          ),
                          Text(
                            widget.title,
                          ),
                          Text(
                            '2',
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ],
                      ),
                      Row(
                        //smainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            iconSize: 40.0,
                            onPressed: () => {},
                            icon: Icon(
                              Icons.remove_circle,
                            ),
                          ),
                          IconButton(
                            iconSize: 40.0,
                            onPressed: () => {},
                            icon: Icon(
                              Icons.add_circle,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            iconSize: 40.0,
                            onPressed: () => {},
                            icon: Icon(
                              Icons.remove_circle,
                            ),
                          ),
                          IconButton(
                            iconSize: 40.0,
                            onPressed: () => {},
                            icon: Icon(
                              Icons.add_circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 100.0,
              width: 70.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://d1si3tbndbzwz9.cloudfront.net/basketball/team/22/logo.png"))),
            ),
          ],
        ),
      ),
    );
  }
}
