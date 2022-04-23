import 'package:flutter/material.dart';

class ErroCarregarDadosPage extends StatelessWidget {
  final String textoErro;
  final String tituloPagina;

  ErroCarregarDadosPage({Key? key, required this.textoErro, required this.tituloPagina}) : super(key: key);

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
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Center(
                  child: Icon(
                Icons.clear_rounded,
                color: Colors.red,
                size: 50,
              )),
              Center(
                child: Text(textoErro),
              )
            ]),
          )),
    );
  }
}
