import 'package:flutter/material.dart';

import 'contador_texto.dart';

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
          heroTag: null,
          mini: true,
          child: Text(
            '${widget.label.substring(0, 1)}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).highlightColor,
          onPressed: () => _updateValue(true),
        ),
        ContadorTexto(_value, widget.color),
        FloatingActionButton(
          heroTag: null,
          mini: true,
          child: Text(
            '${widget.label.substring(1, 2)}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).highlightColor,
          onPressed: () => _updateValue(false),
        ),
      ],
    );
  }
}
