import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/game_model.dart';

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
              ScopedModelDescendant<GameScopedModel>(
                  builder: (context, child, gameModel) {
                return ListTile(
                    leading: Icon(Icons.disc_full),
                    title: Text('Limpiar DB'),
                    onTap: () {
                      _showDialog(context, gameModel);
                    });
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, GameScopedModel model) async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Limpiar DB"),
          content: new Text("Limpiamos firestore, seguro ? "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("SI"),
              onPressed: () {
                model.deleteCollection();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
