import 'package:flutter/material.dart';

class CriarRequisicaoPage extends StatefulWidget {
  const CriarRequisicaoPage({Key? key}) : super(key: key);

  @override
  State<CriarRequisicaoPage> createState() => _CriarRequisicaoPageState();
}

class _CriarRequisicaoPageState extends State<CriarRequisicaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Requisição'),
      ),
      body: Center(),
    );
  }
}
