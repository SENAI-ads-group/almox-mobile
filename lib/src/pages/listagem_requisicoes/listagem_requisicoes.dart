import 'package:almox_mobile/src/model/status_requisicao.dart';
import 'package:almox_mobile/src/pages/home/home_controller.dart';
import 'package:almox_mobile/src/services/requisicao_service.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_requisicoes.widget.dart';
import 'package:flutter/material.dart';

import 'package:almox_mobile/src/pages/home/home_page.dart';

import '../../model/requisicao_model.dart';

class ListagemRequisicoesPage extends PaginaNavegacao {
  ListagemRequisicoesPage() : super(child: _ListagemRequisicoesPage(), botaoNavegacao: BotaoNavegacaoRequisicoes());
}

class _ListagemRequisicoesPage extends StatefulWidget {
  const _ListagemRequisicoesPage({Key? key}) : super(key: key);

  @override
  State<_ListagemRequisicoesPage> createState() => _ListagemRequisicoesPageState();
}

class _ListagemRequisicoesPageState extends State<_ListagemRequisicoesPage> {
  final HomeController homeController = HomeController();
  final RequisicaoService requisicaoService = RequisicaoService();

  List<RequisicaoModel> requisicoes = [];

  @override
  void initState() {
    super.initState();
    requisicaoService.fetchRequisicao().then(
          (value) => setState(() => requisicoes = value),
        );

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
  }

  Card _cardRequisicao(RequisicaoModel requisicao) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)), side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: ListTile(
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
          trailing: Text(requisicao.status.descricao,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: requisicoes.map(_cardRequisicao).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
