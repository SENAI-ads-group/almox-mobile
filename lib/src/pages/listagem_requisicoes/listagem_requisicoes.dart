import 'package:almox_mobile/src/model/status_requisicao.dart';
import 'package:almox_mobile/src/pages/criar_requisicao/criar_requisicao_page.dart';
import 'package:almox_mobile/src/pages/home/home_bloc.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_requisicoes.widget.dart';
import 'package:flutter/material.dart';

import 'package:almox_mobile/src/pages/home/home_page.dart';

import '../../model/requisicao_model.dart';

class ListagemRequisicoesPage extends PaginaNavegacao {
  final HomeBloc homeBloc = HomeBloc();

  ListagemRequisicoesPage()
      : super(
            child: _ListagemRequisicoesPage(),
            botaoNavegacao: BotaoNavegacaoRequisicoes());
}

class _ListagemRequisicoesPage extends StatelessWidget {
  final HomeBloc homeBloc = HomeBloc();

  _ListagemRequisicoesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeBloc.indexPaginaChangeNotifier.addListener(() {
      if (homeBloc.indexPaginaAtual == 0) {
        homeBloc.setBotaoAcao(
            floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/criarRequisicao'),
          child: Icon(Icons.add),
        ));
      }
    });

    return Container(
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: requisicoes
                      .map((RequisicaoModel requisicao) =>
                          _cardRequisicao(requisicao))
                      .toList(),
                ),
              ),
            ],
          )),
    );
  }

  List<RequisicaoModel> requisicoes = [
    RequisicaoModel(
        dataRequisicao: "20/12/2021",
        departamento: "Financeiro",
        nome_almoxarife: "Marcos Aurélio",
        nome_requisitante: "Mathias Conceição",
        statusRequisicao: StatusRequisicao.ATENDIMENTO),
    RequisicaoModel(
        dataRequisicao: "12/03/2022",
        departamento: "Diretoria",
        nome_almoxarife: "Alexandre Nogueira",
        nome_requisitante: "Eduardo Mansur",
        statusRequisicao: StatusRequisicao.ENTREGUE)
  ];

  ListView _filtroStatus() => ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        children: requisicoes
            .map(
              (g) => TextButton(
                onPressed: () {},
                child: Text(g.statusRequisicao.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ),
            )
            .toList(),
      );

  Card _cardRequisicao(RequisicaoModel requisicao) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
      child: ListTile(
        //horizontalTitleGap: 16.0,
        title: Text(
          requisicao.departamento + "\n" + "" + requisicao.dataRequisicao,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(requisicao.dataRequisicao.toString()),
            Text(requisicao.nome_almoxarife.toString()),
          ],
        ),
        trailing: Text("" + requisicao.statusRequisicao.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
