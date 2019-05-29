import 'package:flutter/material.dart';

class CircleText extends StatelessWidget {
  final String texto;

  CircleText(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 30.0,
      decoration: new BoxDecoration(
          color: Theme.of(context).highlightColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Center(
          child: Text(
        '$texto',
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}