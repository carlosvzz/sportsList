import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_list/screens/homepage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  final Firestore firestore = Firestore();
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sports Consensus',
      theme: _myTheme(),
      home: MyHomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('es', 'MX'), // Spanish
      ],
    );
  }
}

ThemeData _myTheme() {
  const Color myPrimaryColor = Color(0xFF005DAB);
  const Color myAccentColor = Color(0xFFFCB034);

  return ThemeData(
      brightness: Brightness.dark,
      //Texans
      // primaryColor: Color(0xFF001331),
      // accentColor: Color(0xFFB82633),
      //Tigres
      primaryColor: myPrimaryColor,
      accentColor: myAccentColor,
      buttonColor: myPrimaryColor,
      textTheme: TextTheme(
        headline: TextStyle(
            fontSize: 25.0, fontWeight: FontWeight.bold, color: myAccentColor),
        title: TextStyle(
            fontSize: 30.0, fontStyle: FontStyle.italic, color: Colors.green),
        body1: TextStyle(
          fontSize: 18.0,
        ),
        body2: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        display1: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white70),
        display2: TextStyle(fontSize: 16.0, color: myAccentColor),
        display3: TextStyle(fontSize: 14.0, color: myAccentColor),
        display4: TextStyle(
            fontSize: 15.0, color: Colors.white70, fontWeight: FontWeight.bold),
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
