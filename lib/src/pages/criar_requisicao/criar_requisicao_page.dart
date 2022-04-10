import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/widgets/botao_acao_widget.dart';
import 'package:almox_mobile/src/widgets/card_produto/botoes_adicionar_remover.dart';

class CriarRequisicaoPage extends StatefulWidget {
  const CriarRequisicaoPage({Key? key}) : super(key: key);

  @override
  State<CriarRequisicaoPage> createState() => _CriarRequisicaoPageState();
}

class _CriarRequisicaoPageState extends State<CriarRequisicaoPage> {
  List<ProdutoModel> produtosSelecionados = [];

  @override
  Widget build(BuildContext context) {
    _pesquisarProdutos() async {
      List<ProdutoModel> produtosSelecionadosNaPesquisa =
          await Navigator.pushNamed(context, '/pesquisarProdutos')
              as List<ProdutoModel>;

      setState(() {
        produtosSelecionados.addAll(produtosSelecionadosNaPesquisa
            .where((p) => !produtosSelecionados.any((p2) => p2.id == p.id)));
      });
    }

    _cardProduto(ProdutoModel produto) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
          child: ListTile(
              onTap: () => {},
              title: Text(produto.descricao),
              subtitle: Text(produto.grupo.descricao),
              trailing: BotoesAdicionarRemoverProduto(
                  onRemoverPressed: () {}, onAdicionarPressed: () {})),
        );

    return Scaffold(
        appBar: AppBar(
          title: Text('Nova Requisição'),
        ),
        body: Center(
          child: Container(
            color: Color.fromRGBO(251, 252, 255, 1),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text(
                            'Incluir',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          onPressed: _pesquisarProdutos,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          child: Icon(Icons.camera_alt),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: produtosSelecionados
                          .map((ProdutoModel produto) => _cardProduto(produto))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() => {}),
          child: Icon(Icons.check),
        ));
  }
}
