import 'package:almox_mobile/src/pages/criar_requisicao/criar_requisicao_page.dart';
import 'package:almox_mobile/src/pages/home/home_bloc.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_requisicoes.widget.dart';
import 'package:flutter/material.dart';

import 'package:almox_mobile/src/pages/home/home_page.dart';

class ListagemRequisicoesPage extends PaginaNavegacao {
  final HomeBloc homeBloc = HomeBloc();

  ListagemRequisicoesPage() : super(child: _ListagemRequisicoesPage(), botaoNavegacao: BotaoNavegacaoRequisicoes());
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

    return Center(
      child: Text("Tela de 'Minhas Requisições'"),
    );
  }
}
