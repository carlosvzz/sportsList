import 'package:flutter/material.dart';
import 'package:sports_list/helpers/format_date.dart';
import 'package:sports_list/models/game.dart';
import 'package:sports_list/widgets/custom_step.dart';
import 'circle_text.dart';

class CardGame extends StatelessWidget {
  CardGame(this.gameData);
  final Game gameData;

  @override
  Widget build(BuildContext context) {
    String labelMain = 'ML';
    String labelOverUnder = 'o/u';
    String labelExtra = '';
    String dateFormat = gameData.time;
    bool isAmFoot = false;

    if (gameData.idSport == 'NFL' || gameData.idSport == 'NCAAF') {
      isAmFoot = true;
      dateFormat =
          formatDate(gameData.date, [D, ' ', dd]) + '\n' + gameData.time;
    }

    // MAIN  >> NFL y NBA = Spread || NHL y MLB es ML
    // EXTRA >> NFL y NBA = ML || MLB y NHL no aplica
    if (gameData.idSport.contains('NFL') || gameData.idSport.contains('NBA')) {
      labelMain = 'SP +/-';
      labelExtra = 'ML';
    }

    Widget extraStep() {
      if (gameData.idSport.contains('NHL') ||
          gameData.idSport.contains('MLB')) {
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
                gameData.colorExtra),
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
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isAmFoot ? 60 : 45,
                  child: Text(
                    dateFormat,
                    style: Theme.of(context).textTheme.display2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    '${gameData.homeTeam.name}',
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
              CustomStep(gameData.id, 'away', '', gameData.countAway,
                  gameData.colorAway),
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
                  gameData.colorHome),
            ],
          ),
          SizedBox(
            height: 5.0,
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
              CustomStep(gameData.id, 'overunder', 'OU',
                  gameData.countOverUnder, gameData.colorOverUnder),
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
