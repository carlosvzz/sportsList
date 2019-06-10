//Lista con fecha ini y fin para partidos, segun dateOrig
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

List<DateTime> getSportDates(String idSport, DateTime dateOrig) {
  List<DateTime> listDates = new List<DateTime>(2);
  // por default es la misma fecha inicial / final para US sports
  listDates[0] = dateOrig;
  listDates[1] = dateOrig;

  if (idSport.toUpperCase().contains('SOCCER')) {
    // SOCCER es de Martes=Jueves y Viernes-Lunes
    List<int> diff = new List<int>(2);
    switch (dateOrig.weekday) {
      case DateTime.monday:
        diff[0] = 3;
        diff[1] = 0;
        break;

      case DateTime.tuesday:
        diff[0] = 0;
        diff[1] = 2;
        break;

      case DateTime.wednesday:
        diff[0] = 1;
        diff[1] = 1;
        break;

      case DateTime.thursday:
        diff[0] = 2;
        diff[1] = 0;
        break;

      case DateTime.friday:
        diff[0] = 0;
        diff[1] = 3;
        break;

      case DateTime.saturday:
        diff[0] = 1;
        diff[1] = 2;
        break;

      case DateTime.sunday:
        diff[0] = 2;
        diff[1] = 1;
        break;
      default:
    }
    listDates[0] = dateOrig.subtract(Duration(days: diff[0]));
    listDates[1] = dateOrig.add(Duration(days: diff[1]));
  }

  return listDates;
}

/// Convierte una hora AM/PM en formato de 24 horas
String convertirHora24(String hora) {
  //hora viene como 7:00AM o 5:30PM
  final int pos = hora.indexOf(':');
  int parteHora = int.parse(hora.substring(0, pos));
  int parteMin = int.parse(hora.substring(pos + 1, pos + 3));

  //Convertir hora a 24 H (AM se queda igual)
  if (hora.contains('PM') == true) {
    if (parteHora < 12) parteHora += 12;
  }
  //Restar 1 hora para Central Time
  parteHora -= 1;

  String horaTexto = _addLeadingZero(parteHora);
  String minTexto = _addLeadingZero(parteMin);

  return horaTexto + ':' + minTexto;
}

// Agregar 0 a la derecha en horas/minutos
String _addLeadingZero(int value) {
  if (value < 10) return '0$value';
  return value.toString();
}

// Lista con Fecha inicial y Final de cada Fixture por tipo Deporte
Future<List<String>> getLimitDates(String idSport) async {
  List<String> lista = ['', ''];
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  int todayInt = int.parse(formatDate(today, ['yyyy', 'mm', 'dd']));

  try {
    CollectionReference collectionRef =
        Firestore.instance.collection("fixtures");

    QuerySnapshot collectionSnapshot;
    // Inicial
    collectionSnapshot = await collectionRef
        .where('idSport', isEqualTo: idSport)
        .where('gameDate', isGreaterThanOrEqualTo: todayInt)
        .orderBy('gameDate')
        .limit(1)
        .getDocuments();

    if (collectionSnapshot.documents.length > 0) {
      DateTime dateAux;

      int seconds = collectionSnapshot.documents[0].data['gameTimestamp'];
      dateAux = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      lista[0] = formatDate(dateAux, ['D', ' ', 'dd', '/', 'M']);

      // Final
      collectionSnapshot = await collectionRef
          .where('idSport', isEqualTo: idSport)
          .where('gameDate', isGreaterThanOrEqualTo: todayInt)
          .orderBy('gameDate', descending: true)
          .limit(1)
          .getDocuments();

      if (collectionSnapshot.documents.length > 0) {
        int seconds = collectionSnapshot.documents[0].data['gameTimestamp'];
        dateAux = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        lista[1] = formatDate(dateAux, ['D', ' ', 'dd', '/', 'M']);
      }
    }
  } catch (e) {
    throw Exception('Datos no obtenidos. _getGamesFirestore ${e.toString()}');
  }

  return lista;
}
