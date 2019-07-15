import 'package:flutter/material.dart';
import 'package:sports_list/screens/listGames/list_games.dart';

class ContenedorJuegos extends StatefulWidget {
  @override
  _ContenedorJuegosState createState() => _ContenedorJuegosState();
}

class _ContenedorJuegosState extends State<ContenedorJuegos> {
  TextEditingController _textController = new TextEditingController();
  String filtroEquipo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            new Icon(
              Icons.search,
              color: _textController.text.length > 0
                  ? Colors.lightBlueAccent
                  : Colors.grey,
            ),
            new SizedBox(
              width: 10.0,
            ),
            new Expanded(
              child: new Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    new TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(hintText: 'Team'),
                      onChanged: (texto) {
                        setState(() {
                          filtroEquipo = texto;
                        });
                      },
                      controller: _textController,
                    ),
                    _textController.text.length > 0
                        ? new IconButton(
                            icon: new Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                filtroEquipo = null;
                                _textController.clear();
                              });
                            })
                        : new Container(
                            height: 0.0,
                          )
                  ]),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Flexible(child: ListGames(filtroEquipo)),
      ],
    );
  }
}
