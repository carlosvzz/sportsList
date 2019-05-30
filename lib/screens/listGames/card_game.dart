import 'package:flutter/material.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/stepper_touch.dart';

import 'circle_text.dart';

class CardGame extends StatelessWidget {
  CardGame(this.gameData, this.setContadores);

  final Game gameData;
  final Function setContadores;

  @override
  Widget build(BuildContext context) {
    String labelMain = 'ML';
    String labelOverUnder = 'O/U';
    String labelExtra = '';

    print('el sport es ${gameData.idSport} y el id es ${gameData.id}');

    // MAIN  >> NFL y NBA = Spread || NHL y MLB es ML
    // EXTRA >> NFL y NBA = ML || NHL y MLB no aplica
    if (gameData.idSport.contains('NFL') || gameData.idSport.contains('NBA')) {
      labelMain = 'SP +/-';
      labelExtra = 'ML';
    }

    Widget extraStep() {
      if (gameData.idSport.contains('NFL') ||
          gameData.idSport.contains('NBA')) {
        return CustomStep(gameData.id, 'extra', gameData.countExtra,
            gameData.colorExtra, setContadores);
      } else {
        return SizedBox(width: 110.0);
      }
    }

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
                    '${gameData.awayTeam.name}',
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
                    '${gameData.homeTeam.name}',
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
              CircleText('${gameData.awayTeam.abbreviation}'),
              SizedBox(
                width: 5,
              ),
              CircleText('${gameData.homeTeam.abbreviation}'),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          ////////////////////////////////////////////////////////
          // STEPPERS MAIN --
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Text(
                  '$labelMain',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomStep(gameData.id, 'away', gameData.countAway,
                  gameData.colorAway, setContadores),
              SizedBox(width: 5.0),
              CustomStep(gameData.id, 'home', gameData.countHome,
                  gameData.colorHome, setContadores),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          ////////// STEPPERS RENGLON 2 O/U + EXTRA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              SizedBox(width: 5.0),
              extraStep(),
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
    print('el id del step es $id');

    String _label = '+-';
    if (custType == 'overunder') {
      _label = 'OU';
    } else if (custType == 'extra') {
      _label = '12';
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
