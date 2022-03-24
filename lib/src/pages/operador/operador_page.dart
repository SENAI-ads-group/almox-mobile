import 'package:almox_mobile/src/pages/home/home_bloc.dart';
import 'package:almox_mobile/src/pages/home/home_page.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_operador_widget.dart';
import 'package:flutter/material.dart';

class OperadorPage extends PaginaNavegacao {
  OperadorPage()
      : super(child: _OperadorPage(), botaoNavegacao: BotaoNavegacaoOperador());
}

class _OperadorPage extends StatelessWidget {
  final HomeBloc homeBloc = HomeBloc();
  _OperadorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeBloc.indexPaginaChangeNotifier.addListener(() {
      if (homeBloc.indexPaginaAtual == 1) {
        homeBloc.setBotaoAcao(floatingActionButton: null);
      }
    });

    return Center(
      child: Text('Tela de Operador'),
    );
  }
}
