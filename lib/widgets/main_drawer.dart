import 'package:flutter/material.dart';

class CustomMenu {
  final String nombre;
  final IconData icono;
  CustomMenu(this.nombre, this.icono);
}

class MainDrawer extends StatelessWidget {
  MainDrawer(this.fnSetActualSports);
  final Function fnSetActualSports;

  static final List<CustomMenu> _listMenuData = [
    new CustomMenu('Liga MX', Icons.ac_unit),
    new CustomMenu('MLB', Icons.backspace),
    new CustomMenu('NBA', Icons.cached),
    new CustomMenu('NHL', Icons.dashboard),
    new CustomMenu('NFL', Icons.edit),
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
        this.fnSetActualSports(data.nombre);
        Navigator.pop(context);
      },
    );
  }
}
