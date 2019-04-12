import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
      children: <Widget>[
       const DrawerHeader(child: Center(child: Text('SPORTS'))),
        new ListTile(
          leading: Icon(Icons.screen_lock_portrait),
          title: new Text('MLB'),
          onTap: () {},
        ),
        new ListTile(
          leading: Icon(Icons.screen_lock_portrait),
           title: new Text('NHL'),
          onTap: () {},
        ),
        new ListTile(
          leading: Icon(Icons.screen_lock_portrait),
           title: new Text('NBA'),
          onTap: () {},
        ),
        new ListTile(
          leading: Icon(Icons.screen_lock_portrait),
           title: new Text('NFL'),
          onTap: () {},
        ),
      ],
    ));
  }
}