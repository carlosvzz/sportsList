import 'package:flutter/material.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/stepper_touch.dart';

class CardGame extends StatelessWidget {
  CardGame(this.gameData, this.setContadores);

  final Game gameData;
  final Function setContadores;

  Widget circleText(BuildContext context, String texto) {
    return Container(
      width: 100.0,
      height: 30.0,
      decoration: new BoxDecoration(
          color: Theme.of(context).highlightColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Center(
          child: Text(
        '$texto',
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 17.0,
            fontWeight: FontWeight.bold),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    String labelMain = 'ML';
    String labelOverUnder = 'O/U';
    String labelExtra = '';

    // MAIN  >> NFL y NBA = Spread || NHL y MLB es ML
    // EXTRA >> NFL y NBA = ML || NHL y MLB no aplica
    if (gameData.idSport.contains('NFL') || gameData.idSport.contains('NBA')) {
      labelMain = 'SP +/-';
      labelExtra = 'ML';
    }

    Widget extraStep() {
      if (gameData.idSport.contains('NFL')) {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '${gameData.awayTeam.name}',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.left,
                ),
                Container(
                  width: 130,
                  child: Text(
                    '${gameData.time}',
                    style: Theme.of(context).textTheme.display1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  '${gameData.homeTeam.name}',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.right,
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
              circleText(context, '${gameData.awayTeam.abbreviation}'),
              SizedBox(
                width: 5,
              ),
              circleText(context, '${gameData.homeTeam.abbreviation}'),
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
    String _label = '++';
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
