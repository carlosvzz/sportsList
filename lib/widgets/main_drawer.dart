import 'package:flutter/material.dart';

class ItemMenu {
  final String nombre;
  final IconData icono;

  ItemMenu(this.nombre, this.icono);
}

class MainDrawer extends StatelessWidget {
  final Function fnSetActualSports;

  MainDrawer(this.fnSetActualSports);

  static final List<ItemMenu> _listViewData = [
    new ItemMenu('Liga MX (ml)', Icons.ac_unit),
    new ItemMenu('Liga MX (ou)', Icons.ac_unit),
    new ItemMenu('MLB', Icons.backspace),
    new ItemMenu('NBA', Icons.cached),
    new ItemMenu('NBA (ou)', Icons.cached),
    new ItemMenu('NHL', Icons.dashboard),
    new ItemMenu('NFL', Icons.edit),
    new ItemMenu('NFL (ou)', Icons.edit),
  ];

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.all(10.0),
        children: _listViewData
            .map(
              (data) => ListTile(
                    leading: Icon(data.icono),
                    title: Text(data.nombre),
                    onTap: () {
                      this.fnSetActualSports(data.nombre);
                      Navigator.pop(context);
                    },
                  ),
            )
            .toList(),
      ),
    ));
  }
}
