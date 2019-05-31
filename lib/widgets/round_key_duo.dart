import 'package:flutter/material.dart';

class RoundKeyDuo extends StatefulWidget {
  final String label;
  final Color color;
  final int initialValue;
  final ValueChanged<int> onChanged;

  RoundKeyDuo(this.label, this.color, this.initialValue, this.onChanged);

  @override
  _RoundKeyDuoState createState() => _RoundKeyDuoState();
}

class _RoundKeyDuoState extends State<RoundKeyDuo> {
  int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    void _updateValue(bool isSum) {
      setState(() {
        if (isSum) {
          _value++;
        } else {
          _value--;
        }
      });

      if (widget.onChanged != null) {
        widget.onChanged(_value);
      }
    }

    // Mini es para renglon extras. El label indica la accion
    return Row(
      children: <Widget>[
        FloatingActionButton(
          mini: true,
          child: Text(
            'O',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).highlightColor,
          onPressed: () => _updateValue(true),
        ),
        ContadorTexto(_value),
        FloatingActionButton(
          mini: true,
          child: Text(
            'U',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).highlightColor,
          onPressed: () => _updateValue(false),
        ),
      ],
    );
  }
}

class ContadorTexto extends StatelessWidget {
  final int value;

  const ContadorTexto(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: new BoxDecoration(
          color: Theme.of(context).buttonColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Center(
          child: Text(
        '$value',
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 17.0,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}
