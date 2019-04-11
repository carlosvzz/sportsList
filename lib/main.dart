import 'package:flutter/material.dart';
import './pages/sports.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _myTheme(),
      home: MyHomePage(title: 'Sports List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: new Drawer(
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
      )),
      body: Sports(),
    );
  }
}

ThemeData _myTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      //Texans
      // primaryColor: Color(0xFF001331),
      // accentColor: Color(0xFFB82633),
      //Tigres
      primaryColor: Color(0xFF005DAB),
      accentColor: Color(0xFFFCB034),
      //fontFamily: 'Roboto',
      buttonColor: Color(0xFF005DAB),
      textTheme: TextTheme(
        headline: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCB034)),
        title: TextStyle(
            fontSize: 30.0, fontStyle: FontStyle.italic, color: Colors.green),
        body1: TextStyle(
          fontSize: 18.0,
        ),
        body2: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        button: TextStyle(
          fontSize: 17.0,
        ),
      ),
      accentTextTheme: TextTheme(
        body1: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCB034)),
        body2: TextStyle(
            fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.green),
      ));
}
