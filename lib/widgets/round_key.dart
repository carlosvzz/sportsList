import 'package:flutter/material.dart';

class RoundKey extends StatefulWidget {
  final Color color;
  final int initialValue;
  final ValueChanged<int> onChanged;

  RoundKey(this.color, this.initialValue, this.onChanged);

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

    void _updateValue(bool isAdd) {
      setState(() {
        if (isAdd) {
          _value++;
        } else {
          _value--;
        }
      });

      if (widget.onChanged != null) {
        widget.onChanged(_value);
      }
    }

    // no Mini es boton de renglon MAIN. El label es el valor real del campo
    // content = FloatingActionButton(
    //   mini: false,
    //   child: Text(
    //     '${_value.toString()}',
    //     style: TextStyle(
    //         fontSize: 25.0,
    //         fontWeight: FontWeight.bold,
    //         color: widget.color == Colors.yellowAccent.shade700
    //             ? Colors.grey.shade600
    //             : Colors.white),
    //   ),
    //   backgroundColor: widget.color,
    //   onPressed: () => _updateValue(),
    // );

    content = GestureDetector(
      onTap: () => _updateValue(true),
      onLongPress: () => _updateValue(false),
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: new BoxDecoration(
            color: widget.color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
            child: Text(
          '${_value.toString()}',
          style: TextStyle(
              color: widget.color == Colors.yellowAccent.shade700
                  ? Colors.grey.shade600
                  : Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.bold),
        )),
      ),
    );

    return content;
  }
}
