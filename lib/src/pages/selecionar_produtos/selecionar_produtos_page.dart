import 'package:almox_mobile/src/model/grupo_model.dart';
import 'package:almox_mobile/src/model/item_requisicao_model.dart';
import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/widgets/card_produto/botoes_adicionar_remover.dart';
import 'package:flutter/material.dart';

class SelecionarProdutosPage extends StatefulWidget {
  const SelecionarProdutosPage({Key? key}) : super(key: key);

  @override
  State<SelecionarProdutosPage> createState() => _SelecionarProdutosPageState();
}

class _SelecionarProdutosPageState extends State<SelecionarProdutosPage> {
  List<ProdutoModel> produtos = [
    ProdutoModel(id: 1, descricao: 'Água Sanitária 5LT', grupo: GrupoModel(descricao: 'Material de Limpeza')),
    ProdutoModel(id: 2, descricao: 'Detergente 500ml', grupo: GrupoModel(descricao: 'Material de Limpeza')),
    ProdutoModel(id: 3, descricao: 'Máscara Descartável', grupo: GrupoModel(descricao: 'E.P.I.')),
    ProdutoModel(id: 4, descricao: 'Luva Descartável', grupo: GrupoModel(descricao: 'E.P.I.')),
  ];

  List<GrupoModel> grupos = [
    GrupoModel(descricao: 'Material de Limpeza'),
    GrupoModel(descricao: 'E.P.I.'),
    GrupoModel(descricao: 'Embalagens'),
    GrupoModel(descricao: 'Material de Escritório')
  ];

  List<ItemRequisicaoModel> itensRequisicao = [];

  List<ProdutoModel> produtosSelecionados = [];

  bool editandoQuantidade = false;

  void _setProdutoSelecionado(ProdutoModel produto, bool? selecionado) {
    setState(() {
      produtosSelecionados = produtosSelecionados.where((p) => p.id != produto.id).toList();

      if (selecionado ?? false) {
        produtosSelecionados.add(produto);
      }
    });
  }

  Future<bool> _onWillPop(BuildContext context) {
    Navigator.pop(context, produtosSelecionados);
    return Future.value(false);
  }

  ListView _filtroGrupos() => ListView(
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

  PreferredSize _appBar(BuildContext context) => PreferredSize(
      child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Adicionar Produto'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _onWillPop(context);
            },
          ),
          bottom: PreferredSize(
            child: Expanded(child: _filtroGrupos()),
            preferredSize: Size(MediaQuery.of(context).size.width, AppBar().preferredSize.height + 60),
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

  void _decrementarQuantidadeItemRequisicao(int indexItemASerDecrementado) {
    setState(() {
      itensRequisicao.asMap().keys.toList().forEach((index) {
        if (index == indexItemASerDecrementado) {
          ItemRequisicaoModel item = itensRequisicao.elementAt(index);
          item.quantidade = item.quantidade - 1;
        }
      });
    });
  }

  void _incrementarQuantidadeItemRequisicao(int indexItemASerIncrementado) {
    setState(() {
      itensRequisicao.asMap().keys.toList().forEach((index) {
        if (index == indexItemASerIncrementado) {
          ItemRequisicaoModel item = itensRequisicao.elementAt(index);
          item.quantidade = item.quantidade + 1;
        }
      });
    });
  }

  Card _cardProduto(ProdutoModel produto) {
    if (!editandoQuantidade) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
        child: ListTile(
          onTap: () => _setProdutoSelecionado(produto, !produtosSelecionados.contains(produto)),
          title: Text(produto.descricao),
          subtitle: Text(produto.grupo.descricao),
          trailing: _checkbox(produto),
        ),
      );
    } else {
      int indexItem = itensRequisicao.indexWhere((item) => item.produto.id == produto.id);
      ItemRequisicaoModel itemRequisicao = itensRequisicao.elementAt(indexItem);
      TextEditingController quantidadeTextFieldController = TextEditingController(text: "${itemRequisicao.quantidade}");
      FocusNode focusNode = FocusNode();
      focusNode.addListener((() {
        //if (focusNode.hasFocus) quantidadeTextFieldController.clear();
      }));

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
        child: ListTile(
          title: Text(produto.descricao),
          subtitle: Text(produto.grupo.descricao),
          trailing: BotoesAdicionarRemoverProduto(
              quantidadeTextField: TextFormField(
                focusNode: focusNode,
                controller: quantidadeTextFieldController,
                onFieldSubmitted: (String valor) {
                  setState(() {
                    itemRequisicao.quantidade = double.parse(valor);
                  });
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
              onRemoverPressed: () => _decrementarQuantidadeItemRequisicao(indexItem),
              onAdicionarPressed: () => _incrementarQuantidadeItemRequisicao(indexItem)),
        ),
      );
    }
  }

  FloatingActionButton _botaoAdicionar() => FloatingActionButton(
        backgroundColor: Color.fromRGBO(200, 230, 201, 1),
        onPressed: () {
          setState(() {
            editandoQuantidade = true;
            itensRequisicao = produtosSelecionados.map((produtoSelecionado) => ItemRequisicaoModel(produto: produtoSelecionado)).toList();
            produtos = produtosSelecionados;
          });
        },
        child: Icon(
          Icons.add_outlined,
          color: Color.fromRGBO(37, 96, 41, 1),
        ),
      );

  FloatingActionButton _botaoConfirmarQuantidades() => FloatingActionButton(
      onPressed: () {},
      child: Icon(
        Icons.check,
      ));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: _appBar(context),
          body: Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: produtos.map((ProdutoModel produto) => _cardProduto(produto)).toList(),
                      ),
                    ),
                  ],
                )),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: () {
            if (produtosSelecionados.isNotEmpty && !editandoQuantidade) {
              return _botaoAdicionar();
            } else if (editandoQuantidade) {
              return _botaoConfirmarQuantidades();
            }
            return null;
          }(),
        ));
  }
}
