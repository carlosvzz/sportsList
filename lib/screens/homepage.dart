import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/custom_date.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/screens/listGames/list_games.dart';
import 'package:sports_list/widgets/main_drawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String actualSport = 'X-Sports';
  IconData actualIcon = Icons.stars;
  List<CustomDate> _listDates;
  GameScopedModel gameModel = GameScopedModel();

  @override
  void initState() {
    super.initState();
    initListDates();
  }

  void initListDates() {
    DateTime _now = DateTime.now();
    DateTime _date =
        DateTime(_now.year, _now.month, _now.day - 1); // Inicia ayer
    _listDates = new List();

    for (var i = 0; i < 7; i++) {
      _listDates.add(new CustomDate(_date));
      _date = _date.add(Duration(days: 1));
    }
    // print(_listDates[0].label);
    // print(_listDates[6].label);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double yourWidth = width / 10;

    void setActualSport(CustomMenu valor) {
      setState(() {
        actualSport = valor.nombre;
        actualIcon = valor.icono;
      });
    }

    Widget regularTab(CustomDate data, bool enabled) {
      return Tab(
        icon: Icon(data.icon, color: enabled ? Colors.white : Colors.grey,),
        text: data.label,
      );
    }

  
    Widget disabledTab(CustomDate data) {
      return InkWell(
        child: Container(
          child: regularTab(data,false),
          //width: double.infinity,
        ),
        onTap: () => {},
      );
    }

    return DefaultTabController(
      length: 7,
      initialIndex: 1,
      child: ScopedModel<GameScopedModel>(
        model: gameModel,
        child: Scaffold(
          drawer: MainDrawer(setActualSport),
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  actualIcon,
                  color: Colors.white70,
                  size: 22.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(actualSport ?? ''),
              ],
            ),
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: 25.0,
                ),
                onPressed: () => {},
              )
            ],
            bottom: TabBar(
              indicatorColor: Theme.of(context).accentColor,
              indicatorWeight: 2.0,
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: yourWidth, right: yourWidth),
              tabs: _listDates.map((data) {
                if (actualSport == 'X-Sports') {
                  return disabledTab(data);
                  //return regularTab(data);
                } else {
                  return regularTab(data,true);
                }
                //return (actualSport == 'X-Sports') ? disabledTab(data) :regularTab(data);
                //return regularTab(data);
              }).toList(),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: _listDates
                .map((data) => ListGames(actualSport, data.date, gameModel))
                .toList(),
          ),
        ),
      ),
    );
  }
}
