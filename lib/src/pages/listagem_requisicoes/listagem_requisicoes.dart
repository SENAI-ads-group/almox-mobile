import 'package:almox_mobile/src/model/status_requisicao.dart';
import 'package:almox_mobile/src/pages/home/home_controller.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_requisicoes.widget.dart';
import 'package:flutter/material.dart';

import 'package:almox_mobile/src/pages/home/home_page.dart';

import '../../model/requisicao_model.dart';

class ListagemRequisicoesPage extends PaginaNavegacao {
  final HomeController homeController = HomeController();

  ListagemRequisicoesPage() : super(child: _ListagemRequisicoesPage(), botaoNavegacao: BotaoNavegacaoRequisicoes());
}

class _ListagemRequisicoesPage extends StatelessWidget {
  final HomeController homeController = HomeController();

  _ListagemRequisicoesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeController.indexPaginaChangeNotifier.addListener(() {
      if (homeController.indexPaginaAtual == 0) {
        homeController.setBotaoAcao(
            floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(200, 230, 201, 1),
          onPressed: () => Navigator.pushNamed(context, '/criarRequisicao'),
          child: Icon(
            Icons.add_outlined,
            color: Color.fromRGBO(37, 96, 41, 1),
          ),
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
                  children: requisicoes.map((RequisicaoModel requisicao) => _cardRequisicao(requisicao)).toList(),
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
        nomeAlmoxarife: "Marcos Aurélio",
        nomeRequisitante: "Mathias Conceição",
        statusRequisicao: StatusRequisicao.emAtendimento),
    RequisicaoModel(
        dataRequisicao: "12/03/2022",
        departamento: "Diretoria",
        nomeAlmoxarife: "Alexandre Nogueira",
        nomeRequisitante: "Eduardo Mansur",
        statusRequisicao: StatusRequisicao.entregue)
  ];

  ListView _filtroStatus() => ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        children: requisicoes
            .map(
              (g) => TextButton(
                onPressed: () {},
                child: Text(g.statusRequisicao.descricao,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)), side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: ListTile(
          title: Text(
            requisicao.departamento,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(requisicao.dataRequisicao),
              Text(requisicao.nomeAlmoxarife),
            ],
          ),
          trailing: Text(requisicao.statusRequisicao.descricao,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }
}
