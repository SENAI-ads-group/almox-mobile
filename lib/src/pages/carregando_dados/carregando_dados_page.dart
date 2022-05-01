import 'package:flutter/material.dart';

class CarregandoDadosPage extends StatelessWidget {
  final String textoCarregando;
  final String tituloPagina;
  PreferredSizeWidget? appBar;

  CarregandoDadosPage({Key? key, required this.textoCarregando, required this.tituloPagina}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tituloPagina),
      ),
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
