import 'package:flutter/material.dart';
import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/custom_step.dart';
import 'circle_text.dart';

class CardGameSoccer extends StatelessWidget {
  CardGameSoccer(this.gameData);
  final Game gameData;

  @override
  Widget build(BuildContext context) {
    //String labelMain = 'ML';
    String labelOverUnder = 'O/U';
    String labelExtra = 'BTTS';
    String dateFormat = formatDate(gameData.date, [D, ' ', dd]);

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
                    textAlign: TextAlign.left,
                    maxLines: 2,
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
                    textAlign: TextAlign.right,
                    maxLines: 2,
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
              CustomStep(gameData.id, 'home', '', gameData.countHome,
                  gameData.colorHome),
              CircleText('${gameData.homeTeam.abbreviation}'),
              CustomStep(gameData.id, 'draw', '', gameData.countDraw,
                  gameData.colorDraw),
              CircleText('${gameData.awayTeam.abbreviation}'),
              CustomStep(gameData.id, 'away', '', gameData.countAway,
                  gameData.colorAway),
            ],
          ),
          SizedBox(
            height: 5.0,
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
              CustomStep(gameData.id, 'overunder', 'OU',
                  gameData.countOverUnder, gameData.colorOverUnder),
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
                  gameData.colorExtra),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
