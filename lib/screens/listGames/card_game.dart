import 'package:flutter/material.dart';
import 'package:sports_list/models/contadores.dart';
import 'package:sports_list/models/feed_games.dart';
import 'package:sports_list/widgets/stepper_touch.dart';

class CardGame extends StatefulWidget {
  CardGame(this._selectedDate, this.gameData);

  final DateTime _selectedDate;
  final Gameentry gameData;

  @override
  State<StatefulWidget> createState() {
    return CardGameState();
  }
}

class CardGameState extends State<CardGame> {
  Color colorGanador = Colors.green;
  Contadores contador;

  @override
  void initState() {
    super.initState();
    contador = new Contadores();
  }

  void setContadores(String id, int value) {
    switch (id) {
      case 'away':
        contador.away = value;
        break;
      case 'home':
        contador.home = value;
        break;
      case 'draw':
        contador.draw = value;
        break;
      case 'over':
        contador.over = value;
        break;
      case 'under':
        contador.under = value;
        break;
      default:
    }

    // Colores
    if (id == 'away' || id == 'home' || id == 'draw') {
      setState(() {
        contador.colorAway =
            (contador.away > contador.home && contador.away > contador.draw)
                ? Colors.green
                : Colors.white;
        contador.colorHome =
            (contador.home > contador.away && contador.home > contador.draw)
                ? Colors.green
                : Colors.white;
        contador.colorDraw =
            (contador.draw > contador.home && contador.away > contador.away)
                ? Colors.green
                : Colors.white;
      });
    } else {
      setState(() {
        contador.colorOver =
            (contador.over > contador.under) ? Colors.green : Colors.white;
        contador.colorUnder =
            (contador.under > contador.over) ? Colors.green : Colors.white;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          // Renglon de Equipos y Hora //
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '${widget.gameData.awayTeam.abbreviation} ${widget.gameData.awayTeam.name}',
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  '${widget.gameData.scheduleStatus == 'Normal' ? widget.gameData.time : widget.gameData.originalTime}',
                  style: Theme.of(context).textTheme.display2,
                ),
                Text(
                  '${widget.gameData.homeTeam.abbreviation} ${widget.gameData.homeTeam.name}',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircleAvatar(
                maxRadius: 27.0,
                backgroundColor: Theme.of(context).accentColor,
                backgroundImage: NetworkImage(
                    "https://tsnimages.tsn.ca/ImageProvider/TeamLogo?seoId=san-antonio-spurs&width=128&height=128"),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StepperTouch(
                        initialValue: contador.away,
                        direction: Axis.horizontal,
                        withSpring: true,
                        mainColor: contador.colorAway,
                        onChanged: (int value) => setContadores('away', value),
                      ),
                      SizedBox(width: 8.0),
                      StepperTouch(
                        initialValue: contador.home,
                        direction: Axis.horizontal,
                        withSpring: true,
                        mainColor: contador.colorHome,
                        onChanged: (int value) => setContadores('home', value),
                      ),
                    ],
                  ),
                  // OVER / UNDER
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('over / under',style: Theme.of(context).textTheme.display1,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // OVER
                      StepperTouch(
                        initialValue: contador.over,
                        direction: Axis.horizontal,
                        withSpring: true,
                        mainColor: contador.colorOver,
                        onChanged: (int value) => setContadores('over', value),
                      ),
                      SizedBox(width: 10.0),
                      // UNDER
                      StepperTouch(
                        initialValue: contador.under,
                        direction: Axis.horizontal,
                        withSpring: true,
                        mainColor: contador.colorUnder,
                        onChanged: (int value) => setContadores('under', value),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
              CircleAvatar(
                maxRadius: 27.0,
                backgroundColor: Theme.of(context).accentColor,
                backgroundImage: NetworkImage(
                    "https://d1si3tbndbzwz9.cloudfront.net/basketball/team/22/logo.png"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
