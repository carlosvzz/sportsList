import 'package:flutter/material.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/stepper_touch.dart';

class CardGame extends StatelessWidget {
  CardGame(this.index,  this.gameData, this.setContadores);
  
  final Game gameData;
  final Function setContadores;
  final int index;

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
                  '${gameData.awayTeam.abbreviation} ${gameData.awayTeam.name}',
                  style: Theme.of(context).textTheme.display1,
                ),
                Text(
                  '${gameData.scheduleStatus == 'Normal' ? gameData.time : gameData.originalTime}',
                  style: Theme.of(context).textTheme.display2,
                ),
                Text(
                  '${gameData.homeTeam.abbreviation} ${gameData.homeTeam.name}',
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
                        initialValue: gameData.countAway,
                        direction: Axis.horizontal,
                        withSpring: true,
                        mainColor: gameData.colorAway,
                        onChanged: (int value) => setContadores(index, 'away', value),
                      ),
                      SizedBox(width: 8.0),
                      StepperTouch(
                        initialValue: gameData.countHome,
                        direction: Axis.horizontal,
                        withSpring: true,
                        mainColor: gameData.colorHome,
                        onChanged: (int value) => setContadores(index, 'home', value),
                      ),
                    ],
                  ),
                  // OVER / UNDER
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'over / under',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // OVER
                      StepperTouch(
                        initialValue: gameData.countOver,
                        direction: Axis.horizontal,
                        withSpring: true,
                        mainColor: gameData.colorOver,
                        onChanged: (int value) => setContadores(index, 'over', value),
                      ),
                      SizedBox(width: 10.0),
                      // UNDER
                      StepperTouch(
                        initialValue: gameData.countUnder,
                        direction: Axis.horizontal,
                        withSpring: true,
                        mainColor: gameData.colorUnder,
                        onChanged: (int value) => setContadores(index, 'under', value),
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
