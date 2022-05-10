import 'package:almox_mobile/src/pages/home/home_controller.dart';
import 'package:almox_mobile/src/pages/listagem_requisicoes/listagem_requisicoes.dart';
import 'package:almox_mobile/src/pages/operador/operador_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<PaginaNavegacao> paginas = [ListagemRequisicoesPage(), OperadorPage()];

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = HomeController();

  _onIndexPaginaChange(int index) {
    setState(() => homeController.indexPaginaAtual = index);
  }

  @override
  void initState() {
    super.initState();
    homeController.indexPaginaAtual = 0;
    homeController.setBotaoAcao(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(200, 230, 201, 1),
        onPressed: () => Navigator.pushNamed(context, '/criarRequisicao'),
        child: Icon(
          Icons.add_outlined,
          color: Color.fromRGBO(37, 96, 41, 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Almox'),
      ),
      body: IndexedStack(
        index: homeController.indexPaginaAtual,
        children: widget.paginas.map((e) => e.child).toList(),
      ),
      floatingActionButton: homeController.floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeController.indexPaginaAtual,
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
