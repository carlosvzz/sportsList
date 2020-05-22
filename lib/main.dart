import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:XSports/providers/filter_model.dart';
import 'package:XSports/providers/game_model.dart';
import 'package:XSports/screens/filters/screen_filter_config.dart';
import 'package:XSports/screens/filters/screen_filter_home.dart';
// import 'package:XSports/providers/user_model.dart';
import 'package:XSports/screens/homepage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:sentry/sentry.dart';

// import './internals/keys.dart';

//final SentryClient _sentry = new SentryClient(dsn: kSentryDSN);

/// Whether the VM is running in debug mode.
bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
// Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
//   print('Caught error: $error');
//   if (isInDebugMode) {
//     print(stackTrace);
//     return;
//   }
//   print('Reporting to Sentry.io...');
//   final SentryResponse response = await _sentry.captureException(
//     exception: error,
//     stackTrace: stackTrace,
//   );

//   if (response.isSuccessful) {
//     print('Success! Event ID: ${response.eventId}');
//   } else {
//     print('Failed to report to Sentry.io: ${response.error}');
//   }
// }

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // This captures errors reported by the Flutter framework.
  // FlutterError.onError = (FlutterErrorDetails details) async {
  //   if (isInDebugMode) {
  //     FlutterError.dumpErrorToConsole(details);
  //   } else {
  //     Zone.current.handleUncaughtError(details.exception, details.stack);
  //   }
  // };

  // final Firestore firestore = Firestore();
  // await firestore.settings(timestampsInSnapshotsEnabled: true);

  //runApp(MyApp());
  // This creates a [Zone] that contains the Flutter application and stablishes
  // an error handler that captures errors and reports them.
  runApp(new MyApp());

  // runZoned<Future<Null>>(() async {
  //   runApp(new MyApp());
  // }, onError: (error, stackTrace) async {
  //   await _reportError(error, stackTrace);
  // });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameModel>(builder: (context) => GameModel()),
          ChangeNotifierProvider<FilterModel>(
            builder: (context) => FilterModel(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sports Consensus',
          theme: _myTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => MyHomePage(),
            'filterHome': (context) => ScreenFilterHome(),
            '/filterConfig': (context) => ScreenFilterConfig(),
          },
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('es', 'MX'), // Spanish
          ],
        ),
      ),
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
        headline5: TextStyle(
            fontSize: 25.0, fontWeight: FontWeight.bold, color: myAccentColor),
        headline6: TextStyle(
            fontSize: 30.0, fontStyle: FontStyle.italic, color: Colors.green),
        bodyText2: TextStyle(
          fontSize: 18.0,
        ),
        bodyText1: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        headline4: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white70),
        headline3: TextStyle(fontSize: 16.0, color: myAccentColor),
        headline2: TextStyle(fontSize: 14.0, color: myAccentColor),
        headline1: TextStyle(
            fontSize: 15.0, color: Colors.white70, fontWeight: FontWeight.bold),
        button: TextStyle(
          fontSize: 17.0,
        ),
      ),
      accentTextTheme: TextTheme(
        bodyText2: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCB034)),
        bodyText1: TextStyle(
            fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.green),
      ));
}
