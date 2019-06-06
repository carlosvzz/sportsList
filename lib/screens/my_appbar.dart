import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'package:sports_list/models/user_model.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final CustomMenu _selectedSport;

  MyAppBar(this._selectedSport);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            _selectedSport.icono,
            color: Colors.white70,
            size: 22.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(_selectedSport.nombre ?? ''),
          Spacer(),
          ScopedModelDescendant<UserScopedModel>(
            builder: (context, child, userModel) {
              if (userModel.isLoading) {
                return CircularProgressIndicator();
              } else {
                return Text(
                  userModel.getOnlyUser(),
                  style: Theme.of(context).textTheme.display1,
                );
              }
            },
          )
        ],
      ),
      iconTheme: IconThemeData(color: Theme.of(context).accentColor),
    );
  }
}
