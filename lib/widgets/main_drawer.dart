import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_list/providers/game_model.dart';
import 'package:sports_list/providers/user_model.dart';
import '../internals/keys.dart';
import 'calendario_juegos.dart';

class MainDrawer extends StatelessWidget {
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
              ListTile(
                leading: Icon(Icons.disc_full),
                title: Text('Limpiar DB antiguos'),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  await _limpiarDB(context, false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.disc_full),
                title: Text('Limpiar DB hoy'),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  await _limpiarDB(context, true);
                  Navigator.pop(context);
                },
              ),
              // VERIFICAR USUARIO
              ListTile(
                leading: Icon(Icons.verified_user),
                title: Text('Iniciar sesión'),
                onTap: () async {
                  Provider.of<UserModel>(context, listen: false)
                      .verifyUser(Key_FirebaseEmail, Key_FirebasePwd);
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

  Future<bool> _limpiarDB(BuildContext context, bool onlyToday) async {
    Navigator.of(context).pop();
    await Provider.of<GameModel>(context).deleteCollection(onlyToday);

    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Limpieza terminada!"),
    ));
    return true;
  }
}
