import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_list/providers/game_model.dart';
import 'package:sports_list/widgets/round_key.dart';
import 'package:sports_list/widgets/round_key_duo.dart';

class CustomStep extends StatelessWidget {
  final String id;
  final String custType;
  final String finalLabel;
  final int custValue;
  final Color custColor;
  CustomStep(
      this.id, this.custType, this.finalLabel, this.custValue, this.custColor);

  @override
  Widget build(BuildContext context) {
    bool _isMini;

//Datos Main
    _isMini = false;

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

    if (_isMini) {
      return RoundKeyDuo(finalLabel, custColor, custValue, (int value) async {
        await Provider.of<GameModel>(context)
            .setContadores(id, custType, value);
      });
    } else {
      return RoundKey(custColor, custValue, (int value) async {
        await Provider.of<GameModel>(context)
            .setContadores(id, custType, value);
      });
    }
  }
}
