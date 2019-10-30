import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportsfilter/screens/widgets/my_modalbottom.dart';

class FilterMyBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // void _showModalSheet(BuildContext context) {
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (builder) {
    //       //return MyModalBottom();
    //       return Container(
    //         child: Text('ModalBottom'),
    //       );
    //     },
    //   );
    // }

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // RaisedButton(
          //   child: Text('clear'),
          //   onPressed: () => Provider.of<GameModel>(context)
          //       .setSelectedSport(kSportVacio, Icons.star),
          // ),
          WidgetFecha(),
          // RaisedButton(
          //   child: Text('sports'),
          //   onPressed: () {
          //     _showModalSheet(context);
          //   },
          // ),
        ],
      ),
    );
  }
}

class WidgetFecha extends StatefulWidget {
  @override
  _WidgetFechaState createState() => _WidgetFechaState();
}

class _WidgetFechaState extends State<WidgetFecha> {
  Future<Null> _selectDate(BuildContext context) async {
    // DateTime _now = DateTime.now();
    // DateTime _today = DateTime(_now.year, _now.month, _now.day);

    // final DateTime picked = await showDatePicker(
    //   context: context,
    //   initialDate: _today,
    //   firstDate: _today.subtract(Duration(days: 1)),
    //   lastDate: _today.add(Duration(days: 10)),
    //   locale: const Locale("es", "ES"),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text(
          'Fecha',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        onPressed: () async {
          await _selectDate(context);
        });
  }
}
