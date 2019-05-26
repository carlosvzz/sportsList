import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/custom_date.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/screens/my_appbar.dart';
import 'package:sports_list/screens/my_bottombar.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  CustomMenu selectedSport = new CustomMenu('X-Sports', Icons.stars);
  CustomDate selectedDate = new CustomDate( DateTime.now());
  GameScopedModel gameModel = GameScopedModel();

 void setActualSport(CustomMenu valor) {
      setState(() {
        selectedSport.nombre = valor.nombre;
        selectedSport.icono = valor.icono;
      });
    }

    void setActualDate(DateTime date) {
      setState(() {
       selectedDate = new CustomDate(date);
      });
    }

  @override
  Widget build(BuildContext context) {
        return ScopedModel<GameScopedModel>(
      model: gameModel,
      child: Scaffold(
        appBar: MyAppBar(selectedSport),
        bottomNavigationBar: MyBottomBar(setActualSport,setActualDate, selectedDate),
         body: selectedSport.nombre == 'X-Sports'
            ? Container()
            : Container(child: Text('Datos'),)
            //: MyBody(actualSport, _listDates, gameModel)
      ),
    );
  }
}
