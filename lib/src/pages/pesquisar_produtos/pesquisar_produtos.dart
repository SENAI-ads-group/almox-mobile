import 'package:almox_mobile/src/model/grupo_model.dart';
import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/widgets/card_produto/botoes_adicionar_remover.dart';
import 'package:flutter/material.dart';

class PesquisarProdutosPage extends StatefulWidget {
  const PesquisarProdutosPage({Key? key}) : super(key: key);

  @override
  State<PesquisarProdutosPage> createState() => _PesquisarProdutosPageState();
}

class _PesquisarProdutosPageState extends State<PesquisarProdutosPage> {
  List<ProdutoModel> produtos = [
    ProdutoModel(
        id: 1,
        descricao: 'Água Sanitária 5LT',
        grupo: GrupoModel(descricao: 'Material de Limpeza')),
    ProdutoModel(
        id: 2,
        descricao: 'Detergente 500ml',
        grupo: GrupoModel(descricao: 'Material de Limpeza')),
    ProdutoModel(
        id: 3,
        descricao: 'Máscara Descartável',
        grupo: GrupoModel(descricao: 'E.P.I.')),
    ProdutoModel(
        id: 4,
        descricao: 'Luva Descartável',
        grupo: GrupoModel(descricao: 'E.P.I.')),
  ];

  List<GrupoModel> grupos = [
    GrupoModel(descricao: 'Material de Limpeza'),
    GrupoModel(descricao: 'E.P.I.'),
    GrupoModel(descricao: 'Embalagens'),
    GrupoModel(descricao: 'Material de Escritório')
  ];

  List<ProdutoModel> produtosSelecionados = [];

  bool editandoQuantidade = false;

  _setProdutoSelecionado(ProdutoModel produto, bool? selecionado) {
    setState(() {
      produtosSelecionados =
          produtosSelecionados.where((p) => p.id != produto.id).toList();

      if (selecionado ?? false) {
        produtosSelecionados.add(produto);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _onWillPop() {
      Navigator.pop(context, produtosSelecionados);
      return Future.value(false);
    }

    _filtroGrupos() => ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          children: grupos
              .map(
                (g) => TextButton(
                  onPressed: () {},
                  child: Text(g.descricao,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
                ),
              )
              .toList(),
        );

    _appBar() => PreferredSize(
        child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Adicionar Produto'),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: _onWillPop,
            ),
            bottom: PreferredSize(
              child: Expanded(child: _filtroGrupos()),
              preferredSize: Size(MediaQuery.of(context).size.width,
                  AppBar().preferredSize.height + 60),
            )),
        preferredSize: Size(MediaQuery.of(context).size.width,
            AppBar().preferredSize.height + 50));

    _checkbox(ProdutoModel produto) {
      bool isChecked = produtosSelecionados.contains(produto);

      return Transform.scale(
        scale: 1.5,
        child: Checkbox(
          value: isChecked,
          onChanged: (valor) => _setProdutoSelecionado(produto, valor),
          shape: CircleBorder(),
          fillColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(
                width: 1.5,
                color: isChecked
                    ? Theme.of(context).primaryColor
                    : Color.fromRGBO(226, 229, 234, 1)),
          ),
          checkColor: Colors.white,
        ),
      );
    }

    _cardProduto(ProdutoModel produto) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
          child: ListTile(
            onTap: () => _setProdutoSelecionado(
                produto, !produtosSelecionados.contains(produto)),
            title: Text(produto.descricao),
            subtitle: Text(produto.grupo.descricao),
            trailing:
                editandoQuantidade && produtosSelecionados.contains(produto)
                    ? BotoesAdicionarRemoverProduto(
                        onRemoverPressed: () {}, onAdicionarPressed: () {})
                    : _checkbox(produto),
          ),
        );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: _appBar(),
          body: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: produtos
                            .map(
                                (ProdutoModel produto) => _cardProduto(produto))
                            .toList(),
                      ),
                    ),
                  ],
                )),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: produtosSelecionados.isNotEmpty
              ? FloatingActionButton(
                  backgroundColor: Color.fromRGBO(200, 230, 201, 1),
                  onPressed: () {
                    setState(() {
                      editandoQuantidade = true;
                    });
                  },
                  child: Icon(
                    Icons.add_outlined,
                    color: Color.fromRGBO(37, 96, 41, 1),
                  ),
                )
              : null),
    );
  }
}
