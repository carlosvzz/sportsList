import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:sports_list/internals/keys.dart';
import 'package:XSports/providers/game_model.dart';
// import 'package:sports_list/providers/user_model.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    GameModel oGame = Provider.of<GameModel>(context);
    // UserModel oUser = Provider.of<UserModel>(context);

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            oGame.selectedSport.icono,
            color: Colors.white70,
            size: 22.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(oGame.selectedSport.nombre ?? ''),
          Spacer(),
          RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text(
              'Filters',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'filterHome');
            },
          ),
          // (oUser.uid?.isNotEmpty ?? false)
          //     ? Text(oUser.getOnlyUser())
          //     : FutureBuilder<bool>(
          //         future: oUser.verifyUser(
          //             Key_FirebaseEmail, Key_FirebasePwd), // async work
          //         builder:
          //             (BuildContext context, AsyncSnapshot<bool> snapshot) {
          //           switch (snapshot.connectionState) {
          //             case ConnectionState.waiting:
          //               return new CircularProgressIndicator();
          //             default:
          //               if (snapshot.hasError)
          //                 return new Text('n/d');
          //               else
          //                 return new Text(oUser.getOnlyUser());
          //           }
          //         },
          //       )
        ],
      ),
      iconTheme: IconThemeData(color: Theme.of(context).accentColor),
    );
  }
}
