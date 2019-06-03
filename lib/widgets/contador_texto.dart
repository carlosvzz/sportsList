import 'package:flutter/material.dart';

class ContadorTexto extends StatelessWidget {
  final int value;
  final Color finalColor;

  const ContadorTexto(this.value, this.finalColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
          color: finalColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Center(
          child: Text(
        '$value',
        style: TextStyle(
            color: Colors.white, //Theme.of(context).accentColor,
            fontSize: 17.0,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}
