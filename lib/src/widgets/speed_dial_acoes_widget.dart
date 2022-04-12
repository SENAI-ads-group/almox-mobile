import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BotaoAcaoRequisicao extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      onOpen: () => print('ABRINDO DIAL'),
      onClose: () => print('ABRINDO DIAL'),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.ads_click_outlined, color: Colors.white),
          backgroundColor: Colors.yellow,
          onTap: () => print('ATENDER'),
          label: 'ATENDER',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.yellow,
        ),
        SpeedDialChild(
          child: Icon(Icons.delivery_dining_sharp, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('ENTREGAR'),
          label: 'ENTREGAR',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.cancel_outlined, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () => print('CANCELAR'),
          label: 'CANCELAR',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.red,
        ),
      ],
    );
  }
}
