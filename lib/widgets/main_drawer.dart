import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/game_model.dart';
import 'package:sports_list/models/user_model.dart';
import '../internals/keys.dart';
import 'calendario_juegos.dart';

class MainDrawer extends StatelessWidget {
  final String idSport;

  MainDrawer(this.idSport);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          DrawerHeader(
            child: new Text("X-Sports"),
            decoration: new BoxDecoration(color: Theme.of(context).accentColor),
          ),
          Column(
            children: <Widget>[
              /// LIMPIAR BD
              ScopedModelDescendant<GameScopedModel>(
                builder: (context, child, gameModel) {
                  return ListTile(
                      leading: Icon(Icons.disc_full),
                      title: Text('Limpiar DB antiguos'),
                      onTap: () async {
                        _limpiarDB(context, gameModel, false);
                      });
                },
              ),
              ScopedModelDescendant<GameScopedModel>(
                builder: (context, child, gameModel) {
                  return ListTile(
                      leading: Icon(Icons.disc_full),
                      title: Text('Limpiar DB hoy'),
                      onTap: () async {
                        _limpiarDB(context, gameModel, true);
                      });
                },
              ),
              // VERIFICAR USUARIO
              ScopedModelDescendant<UserScopedModel>(
                builder: (context, child, userModel) {
                  return ListTile(
                    leading: Icon(Icons.verified_user),
                    title: Text('Iniciar sesión'),
                    onTap: () async {
                      userModel.verifyUser(Key_FirebaseEmail, Key_FirebasePwd);
                    },
                  );
                },
              ),
              // CALENDARIO DE JUEGO
              ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Calendario juegos'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return CalendarioJuegos();
                        });
                  }),
            ],
          ),
        ],
      ),
    );
  }

  void _limpiarDB(
      BuildContext context, GameScopedModel model, bool onlyToday) async {
    Navigator.of(context).pop();
    await model.deleteCollection(onlyToday, this.idSport);
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Limpieza terminada!"),
    ));
  }
}
