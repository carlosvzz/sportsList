import 'package:flutter/material.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/custom_step.dart';
import 'circle_text.dart';

class CardGame extends StatelessWidget {
  CardGame(this.gameData, this.setContadores);

  final Game gameData;
  final Function setContadores;

  @override
  Widget build(BuildContext context) {
    String labelMain = 'ML';
    String labelOverUnder = 'o/u';
    String labelExtra = '';

    // MAIN  >> NFL y NBA = Spread || NHL y MLB es ML
    // EXTRA >> NFL y NBA = ML || MLB = F5 ML |  NHL no aplica
    if (gameData.idSport.contains('NFL') || gameData.idSport.contains('NBA')) {
      labelMain = 'SP +/-';
      labelExtra = 'ML';
    }

    if (gameData.idSport.contains('MLB')) {
      labelExtra = 'F5 ML';
    }

    Widget extraStep() {
      if (gameData.idSport.contains('NHL')) {
        return Container();
      } else {
        return Row(
          children: <Widget>[
            SizedBox(
              width: 40,
              child: Text(
                '$labelExtra',
                style: Theme.of(context).textTheme.display4,
                textAlign: TextAlign.center,
              ),
            ),
            CustomStep(gameData.id, 'extra', 'AH', gameData.countExtra,
                gameData.colorExtra, setContadores),
          ],
        );
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              CustomStep(gameData.id, 'away', '', gameData.countAway,
                  gameData.colorAway, setContadores),
              CircleText('${gameData.awayTeam.abbreviation}'),
              SizedBox(
                width: 40,
                child: Text(
                  '$labelMain',
                  style: Theme.of(context).textTheme.display4,
                  textAlign: TextAlign.center,
                ),
              ),
              CircleText('${gameData.homeTeam.abbreviation}'),
              CustomStep(gameData.id, 'home', '', gameData.countHome,
                  gameData.colorHome, setContadores),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          ////////////////////////////////////////////////////////
          // STEPPERS MAIN --
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     SizedBox(width: 5),
          //     CustomStep(gameData.id, 'away', '', gameData.countAway,
          //         gameData.colorAway, setContadores),
          //     SizedBox(width: 10),
          //     CustomStep(gameData.id, 'home', '', gameData.countHome,
          //         gameData.colorHome, setContadores),
          //     SizedBox(width: 5),
          //   ],
          // ),
          SizedBox(
            height: 8,
          ),
          ////////// STEPPERS RENGLON 2 O/U + EXTRA
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
              // extra solo en NFL y NBA > NHL y MLB se muestra vacío
              extraStep(),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
