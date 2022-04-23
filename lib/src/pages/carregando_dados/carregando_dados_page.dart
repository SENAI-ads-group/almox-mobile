import 'package:flutter/material.dart';

class CarregandoDadosPage extends StatelessWidget {
  final String textoCarregando;
  PreferredSizeWidget? appBar;

  CarregandoDadosPage({Key? key, required this.textoCarregando, appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(),
      body: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          child: Transform.scale(
            scale: 1.5,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: const [
              Center(
                child: CircularProgressIndicator(),
              ),
              Center(
                child: Text('Carregando Produtos...'),
              )
            ]),
          )),
    );
  }
}
