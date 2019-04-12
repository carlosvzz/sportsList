import 'package:flutter/material.dart';
import 'package:sports_list/pages/homepage.dart';
//import 'package:sports_list/widgets/main_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Consensus',
      theme: _myTheme(),
      home: MyHomePage('Sports Consensus'),
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
