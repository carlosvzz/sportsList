import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:XSports/helpers/rutinas.dart';
import 'package:XSports/providers/game_model.dart';
import 'package:XSports/screens/my_appbar.dart';
import 'package:XSports/screens/my_bottombar.dart';
import 'package:XSports/widgets/contenedor_juegos.dart';
import 'package:XSports/widgets/main_drawer.dart';

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
