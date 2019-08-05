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
  List<TablaJuegos> listaLigas = [];

  // Listado de ligas
  listaLigas.add(new TablaJuegos('Soccer MEX'));
  listaLigas.add(new TablaJuegos('Soccer MLS'));
  listaLigas.add(new TablaJuegos('Soccer ENG'));
  listaLigas.add(new TablaJuegos('Soccer ENG2'));
  listaLigas.add(new TablaJuegos('Soccer GER'));
  listaLigas.add(new TablaJuegos('Soccer ESP'));
  listaLigas.add(new TablaJuegos('Soccer ITA'));
  listaLigas.add(new TablaJuegos('Soccer FRA'));
  listaLigas.add(new TablaJuegos('Soccer POR'));
  listaLigas.add(new TablaJuegos('Soccer HOL'));
  listaLigas.add(new TablaJuegos('Soccer HOL2'));

  // Obtener fecha de las distintas ligas
  await Future.wait(listaLigas.map((l) async {
    await getLimitDatesLeague(l);
  }));

  // Armar lista con strings json para mostrar en tabla (ya con formato de fecha y ordenado por fecha ini)
  List<String> listaJson = [];
  List<TablaJuegos> listaOrdenada =
      List.from(listaLigas..sort((a, b) => a.fechaIni.compareTo(b.fechaIni)));

//  print('lista ordenada >>');
  String fechaI;
  String fechaF;
  listaOrdenada.forEach((f) {
    f.fechaIni == DateTime.parse("2100-01-01")
        ? fechaI = ''
        : fechaI = formatDate(f.fechaIni, [D, ' ', dd, '/', M]);
    f.fechaFin == DateTime.parse("2100-01-01")
        ? fechaF = ''
        : fechaF = formatDate(f.fechaFin, [D, ' ', dd, '/', M]);
    String texto = '{"Liga":"${f.liga}","Sig":"$fechaI","Ultima":"$fechaF"}';
    listaJson.add(texto);
  });

  return listaJson;
}

Future<void> getLimitDatesLeague(TablaJuegos l) async {
  try {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int todayInt = int.parse(formatDate(today, ['yyyy', 'mm', 'dd']));

    CollectionReference collectionRef =
        Firestore.instance.collection("fixtures");
    QuerySnapshot collectionSnapshot;

    // Inicial
    collectionSnapshot = await collectionRef
        .where('idSport', isEqualTo: l.liga)
        .where('gameDate', isGreaterThan: todayInt)
        .orderBy('gameDate')
        .limit(1)
        .getDocuments();

    if (collectionSnapshot.documents.length > 0) {
      int seconds = collectionSnapshot.documents[0].data['gameTimestamp'];
      l.fechaIni = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

      // Final
      collectionSnapshot = await collectionRef
          .where('idSport', isEqualTo: l.liga)
          .where('gameDate', isGreaterThanOrEqualTo: todayInt)
          .orderBy('gameDate', descending: true)
          .limit(1)
          .getDocuments();

      if (collectionSnapshot.documents.length > 0) {
        int seconds = collectionSnapshot.documents[0].data['gameTimestamp'];
        l.fechaFin = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      }
    }
    return Future.value(null);
  } catch (e) {
    throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
  }
}

class TablaJuegos {
  String liga;
  DateTime fechaIni;
  DateTime fechaFin;

  TablaJuegos(this.liga) {
    fechaIni = DateTime.parse("2100-01-01");
    fechaFin = DateTime.parse("2100-01-01");
  }
}
