import 'package:flutter/material.dart';

class RoundKey extends StatefulWidget {
  final String label;
  final Color color;
  final int initialValue;
  final ValueChanged<int> onChanged;

  RoundKey(this.label, this.color, this.initialValue, this.onChanged);

  @override
  _RoundKeyState createState() => _RoundKeyState();
}

class _RoundKeyState extends State<RoundKey> {
  int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    void _updateValue() {
      setState(() {
        _value++;
      });

      if (widget.onChanged != null) {
        widget.onChanged(_value);
      }
    }

    // no Mini es boton de renglon MAIN. El label es el valor real del campo
    content = FloatingActionButton(
      mini: false,
      child: Text(
        '${_value.toString()}',
        style: Theme.of(context).textTheme.headline,
      ),
      backgroundColor: widget.color,
      onPressed: () => _updateValue(),
    );

    return content;
  }
}
