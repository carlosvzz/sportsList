import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportsfilter/internals/keys.dart';
// import 'package:sportsfilter/providers/user_model.dart';

class FilterMyAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // UserModel oUser = Provider.of<UserModel>(context);

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Filter bet'),
          Spacer(),
          RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text(
              'X-Sports',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
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
