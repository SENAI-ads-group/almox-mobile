import 'package:almox_mobile/src/model/grupo_model.dart';
import 'package:almox_mobile/src/model/item_requisicao_model.dart';
import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/pages/erro_carregar_dados/erro_carregar_dados_page.dart';
import 'package:almox_mobile/src/services/grupo_service.dart';
import 'package:almox_mobile/src/services/produto_service.dart';
import 'package:almox_mobile/src/widgets/card_produto/botoes_adicionar_remover.dart';
import 'package:almox_mobile/src/pages/carregando_dados/carregando_dados_page.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SelecionarProdutosPage extends StatefulWidget {
  SelecionarProdutosPage({Key? key}) : super(key: key);

  final ProdutoService produtoService = ProdutoService();
  final GrupoService grupoService = GrupoService();

  @override
  State<SelecionarProdutosPage> createState() => _SelecionarProdutosPageState();
}

class _SelecionarProdutosPageState extends State<SelecionarProdutosPage> {
  List<GrupoModel> grupos = [];
  List<ProdutoModel> produtos = [];
  late Future<void> _produtosGruposFuture;

  Future<void> fetch() async {
    produtos = await widget.produtoService.fetchProdutos();
    grupos = await widget.grupoService.fetchGrupos();
  }

  @override
  void initState() {
    _produtosGruposFuture = fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _produtosGruposFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CarregandoDadosPage(textoCarregando: 'Carregando Produtos...', tituloPagina: 'Adicionar Produto');
            default:
              if (snapshot.hasError) {
                return ErroCarregarDadosPage(textoErro: 'Não foi possível carregar os produtos', tituloPagina: 'Adicionar Produto');
              } else {
                return _SelecionarProdutosWidget(produtos: produtos, grupos: grupos);
              }
          }
        });
  }
}

class _SelecionarProdutosWidget extends StatefulWidget {
  final List<GrupoModel> grupos;
  final List<ProdutoModel> produtos;

  _SelecionarProdutosWidget({Key? key, required this.grupos, required this.produtos}) : super(key: key);

  @override
  State<_SelecionarProdutosWidget> createState() => __SelecionarProdutosWidgetState();
}

class __SelecionarProdutosWidgetState extends State<_SelecionarProdutosWidget> {
  List<ProdutoModel> produtosSelecionados = [];

  void _setProdutoSelecionado(ProdutoModel produto, bool? selecionado) {
    setState(() {
      produtosSelecionados = produtosSelecionados.where((p) => p.id != produto.id).toList();

      if (selecionado ?? false) {
        produtosSelecionados.add(produto);
      }
    });
  }

  PreferredSize _appBar(BuildContext context) => PreferredSize(
      child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Adicionar Produto'),
          leading: IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          bottom: TabBar(
            isScrollable: true,
            tabs: widget.grupos
                .map(
                  (g) => Tab(
                    child: Text(g.descricao,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                  ),
                )
                .toList(),
          )),
      preferredSize: Size(MediaQuery.of(context).size.width, AppBar().preferredSize.height + 50));

  Widget _checkbox(ProdutoModel produto) {
    bool isChecked = produtosSelecionados.contains(produto);

    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        value: isChecked,
        onChanged: (valor) => _setProdutoSelecionado(produto, valor),
        shape: CircleBorder(),
        fillColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
        side: MaterialStateBorderSide.resolveWith(
          (states) => BorderSide(width: 1.5, color: isChecked ? Theme.of(context).primaryColor : Color.fromRGBO(226, 229, 234, 1)),
        ),
        checkColor: Colors.white,
      ),
    );
  }

  Column _listagemProdutos(GrupoModel grupo) => Column(
        children: [
          Expanded(
            child: ListView(
              children: widget.produtos
                  .where((ProdutoModel produto) => produto.grupo.id == grupo.id)
                  .map((ProdutoModel produto) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
                        child: ListTile(
                          onTap: () => _setProdutoSelecionado(produto, !produtosSelecionados.contains(produto)),
                          title: Text(produto.descricao),
                          subtitle: Text(produto.grupo.descricao),
                          trailing: _checkbox(produto),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      );

  ListView _chipsProdutosSelecionados() => ListView(
      scrollDirection: Axis.horizontal,
      children: produtosSelecionados
          .map(
            (ProdutoModel produto) => Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Chip(
                  label: Text(produto.descricao),
                )),
          )
          .toList());

  FloatingActionButton _botaoAdicionar() => FloatingActionButton(
        backgroundColor: Color.fromRGBO(200, 230, 201, 1),
        onPressed: () => Navigator.pop(context, produtosSelecionados),
        child: Icon(
          Icons.add_outlined,
          color: Color.fromRGBO(37, 96, 41, 1),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.grupos.length,
      child: Scaffold(
        appBar: _appBar(context),
        body: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            child: Column(
              children: [
                Flexible(
                    child: produtosSelecionados.isEmpty
                        ? SizedBox(height: 16)
                        : Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: SizedBox(height: 60, child: _chipsProdutosSelecionados()))),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: TabBarView(children: widget.grupos.map((GrupoModel grupo) => _listagemProdutos(grupo)).toList())))
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: produtosSelecionados.isNotEmpty ? _botaoAdicionar() : null,
      ),
    );
  }
}
