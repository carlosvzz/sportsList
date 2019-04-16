import 'package:flutter/material.dart';
import 'package:sports_list/models/custom_menu.dart';
import 'custom_icons.dart';



class MainDrawer extends StatelessWidget {
  MainDrawer(this.fnSetActualSports);
  final Function fnSetActualSports;

  static final List<CustomMenu> _listMenuData = [
    new CustomMenu('Liga MX', CustomIcons.soccer_ball),
    new CustomMenu('MLB', CustomIcons.baseball),
    new CustomMenu('NBA', CustomIcons.dribbble),
    new CustomMenu('NHL', CustomIcons.hockey),
    new CustomMenu('NFL', CustomIcons.football),
  ];

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
            children:
                _listMenuData.map((data) => customTile(context, data)).toList(),
          ),
        ],
      ),
    );
  }

  ListTile customTile(BuildContext context, CustomMenu data) {
    return ListTile(
      leading: Icon(data.icono),
      title: Text(data.nombre),
      onTap: () {
        this.fnSetActualSports(data);
        Navigator.pop(context);
      },
    );
  }
}
