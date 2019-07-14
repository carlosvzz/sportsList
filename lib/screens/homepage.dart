import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_list/helpers/rutinas.dart';
import 'package:sports_list/providers/game_model.dart';
import 'package:sports_list/screens/my_appbar.dart';
import 'package:sports_list/screens/my_bottombar.dart';
import 'package:sports_list/widgets/contenedor_juegos.dart';
import 'package:sports_list/widgets/main_drawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GameModel oGame = Provider.of<GameModel>(context);

    return Scaffold(
      appBar: MyAppBar(),
      drawer: MainDrawer(),
      bottomNavigationBar: MyBottomBar(),
      body: oGame.idSport == kSportVacio ? Container() : new ContenedorJuegos(),
    );
  }
}
