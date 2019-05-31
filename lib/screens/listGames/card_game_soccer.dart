import 'package:flutter/material.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/stepper_touch.dart';

import 'circle_text.dart';

class CardGameSoccer extends StatelessWidget {
  CardGameSoccer(this.gameData, this.setContadores);

  final Game gameData;
  final Function setContadores;

  @override
  Widget build(BuildContext context) {
    String labelMain = 'ML';
    String labelOverUnder = 'O/U';
    String labelExtra = 'BTTS';

    return Card(
      child: Column(
        children: <Widget>[
          // Renglon de Equipos //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${gameData.homeTeam.name}',
                    style: Theme.of(context).textTheme.display4,
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 45,
                  child: Text(
                    '${gameData.time}',
                    style: Theme.of(context).textTheme.display2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    '${gameData.awayTeam.name}',
                    style: Theme.of(context).textTheme.display4,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),

          // Renglon de Abreviaciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              CircleText('${gameData.homeTeam.abbreviation}'),
              SizedBox(
                width: 5,
              ),
              CircleText('${gameData.awayTeam.abbreviation}'),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),

          // Steppers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Text(
                  '$labelMain',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomStep(gameData.id, 'home', gameData.countHome,
                  gameData.colorHome, setContadores),
              CustomStep(gameData.id, 'draw', gameData.countDraw,
                  gameData.colorDraw, setContadores),
              CustomStep(gameData.id, 'away', gameData.countAway,
                  gameData.colorAway, setContadores),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(
            height: 8,
          ),

          /////////////////// STEPPERS RENGLON 2 O/U  BTTS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Text(
                  '$labelOverUnder',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomStep(gameData.id, 'overunder', gameData.countOverUnder,
                  gameData.colorOverUnder, setContadores),
              SizedBox(
                width: 100,
              ),
              CustomStep(gameData.id, 'extra', gameData.countExtra,
                  gameData.colorExtra, setContadores),
              SizedBox(
                width: 40,
                child: Text(
                  '$labelExtra',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class CustomStep extends StatelessWidget {
  final String id;
  final String custType;
  final int custValue;
  final Color custColor;
  final Function fnContadores;
  CustomStep(this.id, this.custType, this.custValue, this.custColor,
      this.fnContadores);

  @override
  Widget build(BuildContext context) {
    String _label = '++';
    if (custType == 'overunder') {
      _label = 'OU';
    } else if (custType == 'extra') {
      _label = 'YN';
    }

    return StepperTouch(
        initialValue: custValue,
        direction: Axis.horizontal,
        labels: _label,
        withSpring: true,
        mainColor: custColor,
        onChanged: (int value) => fnContadores(id, custType, value));
  }
}
