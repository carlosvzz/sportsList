import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_list/helpers/format_date.dart';
import 'package:json_table/json_table.dart';

class CalendarioJuegos extends StatefulWidget {
  @override
  _CalendarioJuegosState createState() => _CalendarioJuegosState();
}

class _CalendarioJuegosState extends State<CalendarioJuegos> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: getLimitDates(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: new CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                var json = jsonDecode(snapshot.data.toString());

                return Center(
                    child: JsonTable(
                  json,
                  tableHeaderBuilder: (String header) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          color: Theme.of(context).primaryColor),
                      child: Text(
                        header,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.display3,
                      ),
                    );
                  },
                  tableCellBuilder: (value) {
                    return Container(
                      color: Colors.blue.shade900,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                      child: Text(value,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.subhead),
                    );
                  },
                ));
              }
          }
        });
  }
}

// Lista con Fecha inicial y Final de cada Fixture por tipo Deporte
Future<List<String>> getLimitDates() async {
  List<String> listaResp = new List<String>();

  String text;
  text = await getLimitDatesLeague('Soccer MEX');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer MLS');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer ENG');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer ENG2');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer GER');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer ESP');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer ITA');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer FRA');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer POR');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer HOL');
  listaResp.add(text);
  text = await getLimitDatesLeague('Soccer HOL2');
  listaResp.add(text);

  return listaResp..sort();
}

Future<String> getLimitDatesLeague(String l) async {
  List<String> listaFechas = ['', ''];

  try {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int todayInt = int.parse(formatDate(today, ['yyyy', 'mm', 'dd']));

    CollectionReference collectionRef =
        Firestore.instance.collection("fixtures");
    QuerySnapshot collectionSnapshot;

    // Inicial
    collectionSnapshot = await collectionRef
        .where('idSport', isEqualTo: l)
        .where('gameDate', isGreaterThan: todayInt)
        .orderBy('gameDate')
        .limit(1)
        .getDocuments();

    if (collectionSnapshot.documents.length > 0) {
      DateTime dateAux;

      int seconds = collectionSnapshot.documents[0].data['gameTimestamp'];
      dateAux = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      listaFechas[0] = formatDate(dateAux, [D, ' ', dd, '/', M]);

      // Final
      collectionSnapshot = await collectionRef
          .where('idSport', isEqualTo: l)
          .where('gameDate', isGreaterThanOrEqualTo: todayInt)
          .orderBy('gameDate', descending: true)
          .limit(1)
          .getDocuments();

      if (collectionSnapshot.documents.length > 0) {
        int seconds = collectionSnapshot.documents[0].data['gameTimestamp'];
        dateAux = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        listaFechas[1] = formatDate(dateAux, [D, ' ', dd, '/', M]);
      }
    }

    return '{"Liga":"$l","Sig":"${listaFechas[0]}","Ultima":"${listaFechas[1]}"}';
  } catch (e) {
    throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
  }
}
