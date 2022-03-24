import 'package:almox_mobile/src/pages/home/home_bloc.dart';
import 'package:almox_mobile/src/pages/login/login_page.dart';
import 'package:almox_mobile/src/pages/operador/operador_page.dart';
import 'package:almox_mobile/src/pages/requisicoes_requisitante/requisicoes_requisitante.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_home_widget.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_requisicoes.widget.dart';
import 'package:almox_mobile/src/widgets/botoes_navegacao/botao_navegacao_operador_widget.dart';

class HomePage extends StatefulWidget {
  final List<PaginaNavegacao> paginas = [
    RequisicoesRequisitantePage(),
    OperadorPage()
  ];

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc homeBloc = HomeBloc();

  _onIndexPaginaChange(int index) {
    setState(() => homeBloc.indexPaginaAtual = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Almox'),
      ),
      body: IndexedStack(
        index: homeBloc.indexPaginaAtual,
        children: widget.paginas.map((e) => e.child).toList(),
      ),
      floatingActionButton: homeBloc.floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeBloc.indexPaginaAtual,
        onTap: _onIndexPaginaChange,
        items: widget.paginas.map((pagina) => pagina.botaoNavegacao).toList(),
      ),
    );
  }
}

abstract class PaginaNavegacao {
  Widget child;
  BottomNavigationBarItem botaoNavegacao;

  PaginaNavegacao({required this.child, required this.botaoNavegacao});
}
