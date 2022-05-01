import 'package:flutter/material.dart';

class BotaoAcao extends StatelessWidget {
  VoidCallback? onPressed;
  Widget icon;
  String labelText;

  BotaoAcao(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(labelText,
          style:
              TextStyle(fontSize: 18, color: Color.fromRGBO(16, 115, 219, 1))),
      style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color.fromRGBO(16, 115, 219, 0.5)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}

class Bo extends OutlinedButton {
  Bo({required VoidCallback? onPressed, required Widget child})
      : super(onPressed: onPressed, child: child);
}
