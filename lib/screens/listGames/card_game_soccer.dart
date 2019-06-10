import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/custom_step.dart';
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
    String dateFormat = formatDate(gameData.date, ['D', ' ', dd]);

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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '$dateFormat \n ${gameData.time}',
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

////////////////////////////////////////////////////////
          // Steppers MAIN
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 5),
              CustomStep(gameData.id, 'home', '', gameData.countHome,
                  gameData.colorHome, setContadores),
              CustomStep(gameData.id, 'draw', '', gameData.countDraw,
                  gameData.colorDraw, setContadores),
              CustomStep(gameData.id, 'away', '', gameData.countAway,
                  gameData.colorAway, setContadores),
              SizedBox(width: 5),
            ],
          ),
          SizedBox(
            height: 8,
          ),

          /////////////////// STEPPERS RENGLON 2 O/U  BTTS
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 40,
                child: Text(
                  '$labelOverUnder',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomStep(
                  gameData.id,
                  'overunder',
                  'OU',
                  gameData.countOverUnder,
                  gameData.colorOverUnder,
                  setContadores),
              Spacer(),
              SizedBox(
                width: 40,
                child: Text(
                  '$labelExtra',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomStep(gameData.id, 'extra', 'YN', gameData.countExtra,
                  gameData.colorExtra, setContadores),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
