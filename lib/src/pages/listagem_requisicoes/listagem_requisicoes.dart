import 'package:almox_mobile/src/model/status_requisicao.dart';
import 'package:almox_mobile/src/services/requisicao_service.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/pages/home/home_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/requisicao_model.dart';

class ListagemRequisicoesPage extends StatefulWidget {
  const ListagemRequisicoesPage({Key? key}) : super(key: key);

  @override
  State<ListagemRequisicoesPage> createState() =>
      _ListagemRequisicoesPageState();
}

class _ListagemRequisicoesPageState extends State<ListagemRequisicoesPage> {
  final RequisicaoService requisicaoService = RequisicaoService();

  List<RequisicaoModel> requisicoes = [];

  @override
  void initState() {
    super.initState();
    requisicaoService
        .fetchRequisicao()
        .then((value) => setState(() => requisicoes = value));
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Requisições'),
          bottom: TabBar(
            isScrollable: true,
            tabs: const <Tab>[
              Tab(
                child: Text('Minhas Requisições',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              Tab(
                child: Text('Atendimento de Requisições',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              )
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width,
            AppBar().preferredSize.height + 50));
  }

  Card _cardRequisicao(RequisicaoModel requisicao) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () => Navigator.of(context)
                    .pushNamed('/atenderRequisicao', arguments: requisicao),
                leading: Icon(Icons.check),
                title: Text(
                  requisicao.departamento.descricao,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(requisicao.dataRequisicao.toString()),
                    Text(requisicao.almoxarife.pessoa.nome),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.block_outlined,
                            size: 25,
                            color: Colors.red,
                          )),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
        appBar: _appBar(context),
        body: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(children: [
                  ListView(children: requisicoes.map(_cardRequisicao).toList()),
                  ListView(children: requisicoes.map(_cardRequisicao).toList()),
                ]),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(200, 230, 201, 1),
          onPressed: () => Navigator.pushNamed(context, '/criarRequisicao'),
          child: Icon(
            Icons.add_outlined,
            color: Color.fromRGBO(37, 96, 41, 1),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (i) => {},
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined),
              label: "Requisições",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Operador",
            )
          ],
        ),
      ),
    );
  }
}
