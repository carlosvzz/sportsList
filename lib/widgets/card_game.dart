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
  int contaVisitante;
  int contaLocal;
  Color colorGanador = Colors.green;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contaVisitante = 0;
    contaLocal = 0;
  }

  void actualizarContador(String id, String operador) {
    // Local
    if (id == 'L') {
      setState(() {
        if (operador == '+') {
          contaLocal++;
        } else if (contaLocal > 0) {
          contaLocal--;
        }
      });
    } else {
      setState(() {
        if (operador == '+') {
          contaVisitante++;
        } else if (contaVisitante > 0) {
          contaVisitante--;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => actualizarContador('V', '+'),
              onLongPress: () => actualizarContador('V', '-'),
              child: Padding(
                padding: EdgeInsets.all(7.0),
                child: CircleAvatar(
                  maxRadius: 27.0,
                  backgroundColor: Theme.of(context).accentColor,
                  backgroundImage: NetworkImage(
                      "https://tsnimages.tsn.ca/ImageProvider/TeamLogo?seoId=san-antonio-spurs&width=128&height=128"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                contaVisitante.toString(),
                style: (contaVisitante > contaLocal)
                    ? Theme.of(context).accentTextTheme.body2
                    : Theme.of(context).accentTextTheme.body1,
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    widget.title + ' @ 19:45',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    'o/u 50.25',
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                contaLocal.toString(),
                style: (contaLocal > contaVisitante)
                    ? Theme.of(context).accentTextTheme.body2
                    : Theme.of(context).accentTextTheme.body1,
                textAlign: TextAlign.right,
              ),
            ),
            GestureDetector(
              onTap: () => actualizarContador('L', '+'),
              onLongPress: () => actualizarContador('L', '-'),
              child: Padding(
                padding: EdgeInsets.all(7.0),
                child: CircleAvatar(
                  maxRadius: 27.0,
                  backgroundColor: Theme.of(context).accentColor,
                  backgroundImage: NetworkImage(
                      "https://d1si3tbndbzwz9.cloudfront.net/basketball/team/22/logo.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
