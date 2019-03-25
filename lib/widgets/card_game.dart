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
        height: 100.0,
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
            Container(
              height: 100,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: Text(
                      widget.title,
                    ),),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                      child: Container(
                        width: 250.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                              child: Icon(Icons.add),
                              onPressed: () => {},
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            RaisedButton(
                              child: Icon(Icons.add),
                              onPressed: () => {},
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
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
