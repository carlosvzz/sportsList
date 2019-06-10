import 'package:sports_list/helpers/rutinas.dart';

final List<String> _listaSoccer = [
  'Soccer AMERICA',
  'Soccer MLS',
  'Soccer MEX',
  'Soccer ENG',
  'Soccer GER',
  'Soccer ESP',
  'Soccer ITA',
  'Soccer FRA',
  'Soccer HOL',
  'Soccer POR',
];

Future<void> calendarioJuegos() async {
  List<String> lista = new List<String>();

  _listaSoccer.forEach((s) {
    Future<List<String>> listaFechas = getLimitDates(s);
    //   lista.add('liga:$s,fechaIni:${listaFechas[0]}');
  });

  lista.forEach((f) {
    print('$f');
  });
}
