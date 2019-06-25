import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/custom_date.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/models/user_model.dart';
import 'package:sports_list/screens/my_appbar.dart';
import 'package:sports_list/screens/my_bottombar.dart';
import 'package:sports_list/widgets/main_drawer.dart';
import '../internals/keys.dart';

import 'listGames/list_games.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  CustomMenu selectedSport = new CustomMenu('X-Sports', Icons.stars);
  CustomDate selectedDate = new CustomDate(DateTime.now());
  GameScopedModel gameModel = GameScopedModel();
  UserScopedModel userModel = UserScopedModel();

  @override
  void initState() {
    super.initState();
    userModel.verifyUser(Key_FirebaseEmail, Key_FirebasePwd);
  }

  void setActualSport(CustomMenu valor) {
    setState(() {
      selectedSport.nombre = valor.nombre;
      selectedSport.icono = valor.icono;
    });
    fetchNewGames();
  }

  void setActualDate(DateTime date) {
    setState(() {
      selectedDate = new CustomDate(date);
    });
    fetchNewGames();
  }

  void fetchNewGames() {
    if (selectedSport.nombre != 'X-Sports') {
      gameModel.fetchGames(selectedSport.nombre, selectedDate.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserScopedModel>(
      model: userModel,
      child: ScopedModel<GameScopedModel>(
        model: gameModel,
        child: Scaffold(
          appBar: MyAppBar(selectedSport),
          drawer: MainDrawer(selectedSport.nombre),
          bottomNavigationBar:
              MyBottomBar(setActualSport, setActualDate, selectedDate),
          body: selectedSport.nombre == 'X-Sports'
              ? Container()
              : new ListadoJuegos(
                  selectedSport: selectedSport,
                  selectedDate: selectedDate,
                ),
        ),
      ),
    );
  }
}

class ListadoJuegos extends StatefulWidget {
  ListadoJuegos({
    @required this.selectedSport,
    @required this.selectedDate,
  });

  final CustomMenu selectedSport;
  final CustomDate selectedDate;

  @override
  _ListadoJuegosState createState() => _ListadoJuegosState();
}

class _ListadoJuegosState extends State<ListadoJuegos> {
  TextEditingController _textController = new TextEditingController();
  String filtroEquipo;

  // @override
  // void initState() {
  //   super.initState();
  //   controller.addListener(() {
  //     setState(() {
  //       filtroEquipo = controller.text;
  //     });
  //   });
  // }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            new Icon(
              Icons.search,
              color: _textController.text.length > 0
                  ? Colors.lightBlueAccent
                  : Colors.grey,
            ),
            new SizedBox(
              width: 10.0,
            ),
            new Expanded(
              child: new Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    new TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(hintText: 'Team'),
                      onChanged: (texto) {
                        setState(() {
                          filtroEquipo = texto;
                        });
                      },
                      controller: _textController,
                    ),
                    _textController.text.length > 0
                        ? new IconButton(
                            icon: new Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                filtroEquipo = null;
                                _textController.clear();
                              });
                            })
                        : new Container(
                            height: 0.0,
                          )
                  ]),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Flexible(
            child: ListGames(widget.selectedSport.nombre,
                widget.selectedDate.date, filtroEquipo)),
      ],
    );
  }
}
