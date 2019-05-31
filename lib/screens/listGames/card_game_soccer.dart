import 'package:flutter/material.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/round_key.dart';
import 'package:sports_list/widgets/round_key_duo.dart';
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
                width: 40,
                child: Text(
                  '$labelMain',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
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

          // Steppers MAIN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 5),
              CustomStep(gameData.id, 'home', gameData.countHome,
                  gameData.colorHome, setContadores),
              CustomStep(gameData.id, 'draw', gameData.countDraw,
                  gameData.colorDraw, setContadores),
              CustomStep(gameData.id, 'away', gameData.countAway,
                  gameData.colorAway, setContadores),
              SizedBox(width: 5),
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
                width: 8,
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$labelExtra',
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

class ContadorTexto extends StatelessWidget {
  final int value;

  const ContadorTexto(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
          color: Theme.of(context).buttonColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Center(
          child: Text(
        '$value',
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 17.0,
            fontWeight: FontWeight.bold),
      )),
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
    bool _isMini;
    String _finalLabel;

//Datos Main
    _isMini = false;
    _finalLabel = custValue.toString();

// Datos Extras
    switch (custType) {
      case 'overunder':
        _isMini = true;
        break;
      case 'extra':
        _isMini = true;
        break;

      default:
    }
    //print('valor es $_isMini y $_finalLabel y ${custValue.toString()}');

    if (_isMini) {
      return RoundKeyDuo(_finalLabel, custColor, custValue,
          (int value) => fnContadores(id, custType, value));
    } else {
      return RoundKey(_finalLabel, custColor, custValue,
          (int value) => fnContadores(id, custType, value));
    }
  }
}
