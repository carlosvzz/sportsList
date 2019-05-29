import 'package:flutter/material.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/stepper_touch.dart';

class CardGameSoccer extends StatelessWidget {
  CardGameSoccer(this.gameData, this.setContadores);

  final Game gameData;
  final Function setContadores;

  Widget circleText(BuildContext context, String texto) {
    return Container(
      width: 60.0,
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
    return Card(
      child: Column(
        children: <Widget>[
          // Renglon de Abreviaciones
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                circleText(context, '${gameData.awayTeam.abbreviation}'),
                Text(
                  '${gameData.time}',
                  style: Theme.of(context).textTheme.display1,
                ),
                circleText(context, '${gameData.homeTeam.abbreviation}'),
              ],
            ),
          ),
          // Renglon de Equipos y Hora //
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${gameData.awayTeam.name}',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.left,
                ),
                Text(
                  '${gameData.homeTeam.name}',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),

          // Steppers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 40,
                child: Text(
                  'ML',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomStep(gameData.id, 'away', gameData.countAway,
                  gameData.colorAway, setContadores),
              SizedBox(width: 10.0),
              CustomStep(gameData.id, 'draw', gameData.countDraw,
                  gameData.colorDraw, setContadores),
              SizedBox(width: 10.0),
              CustomStep(gameData.id, 'home', gameData.countHome,
                  gameData.colorHome, setContadores),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 40,
                child: Text(
                  'O/U',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomStep(gameData.id, 'overunder', gameData.countOverUnder,
                  gameData.colorOverUnder, setContadores),
              Container(
                width: 130,
                child: Text(
                  'BTTS Y/N',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomStep(gameData.id, 'extra', gameData.countExtra,
                  gameData.colorExtra, setContadores),
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
