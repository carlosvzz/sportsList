import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sports_list/providers/filter_model.dart';
//import 'package:flutter_selectable_text/flutter_selectable_text.dart';

class FilterMainContainer extends StatefulWidget {
  @override
  _FilterMainContainerState createState() => _FilterMainContainerState();
}

class _FilterMainContainerState extends State<FilterMainContainer> {
  Future<String> _listaJuegos;
  String textoFinal;
  FilterModel oGame;

  @override
  void initState() {
    super.initState();
    oGame = Provider.of<FilterModel>(context, listen: false);
    _listaJuegos = oGame.getGames();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
              child: FutureBuilder<String>(
            future: _listaJuegos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data == null) {
                  return new Text('No hay juegos');
                } else {
                  textoFinal = snapshot.data;
                  return SingleChildScrollView(
                      child: SelectableText(
                    snapshot.data,
                    style: Theme.of(context).textTheme.body1,
                    textAlign: TextAlign.left,
                  ));
                }
              }
            },
          )),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton.icon(
                icon: Icon(Icons.filter_list),
                label: Text("Filtros"),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/filterConfig');
                  setState(() {
                    _listaJuegos = oGame.getGames();
                  });
                },
              ),
              RaisedButton.icon(
                icon: Icon(Icons.content_copy),
                label: Text("Copiar"),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: textoFinal));
                  toast('Texto copiado!!..');
                },
              ),
              RaisedButton.icon(
                icon: Icon(Icons.refresh),
                label: Text("Actualizar"),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  setState(() {
                    _listaJuegos = oGame.getGames();
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
