import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/widgets/botao_acao_widget.dart';

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
              trailing: Wrap(
                runSpacing: 0,
                spacing: 0,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_circle_outlined,
                      color: Color.fromRGBO(220, 38, 38, 1),
                      size: 25,
                    ),
                  ),
                  SizedBox(
                      child: SizedBox(
                          width: 45,
                          child: TextField(
                            textAlign: TextAlign.center,
                          ))),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_circle_outlined,
                      color: Colors.green,
                      size: 25,
                    ),
                  ),
                ],
              )),
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
                        child: BotaoAcao(
                            onPressed: _pesquisarProdutos,
                            icon: Icon(Icons.add, color: Colors.black),
                            labelText: 'Adicionar Item'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: produtosSelecionados
                          .map((ProdutoModel produto) => _cardProduto(produto))
                          .toList(),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton.icon(
                  //         icon: Icon(Icons.add),
                  //         label: Text(
                  //           'Incluir',
                  //           style: TextStyle(fontSize: 18),
                  //         ),
                  //         style: ButtonStyle(
                  //             shape: MaterialStateProperty.all(
                  //                 RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(18.0),
                  //         ))),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  //       child: ElevatedButton(
                  //         style: ButtonStyle(
                  //             shape: MaterialStateProperty.all(
                  //                 RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(18.0),
                  //         ))),
                  //         child: Icon(Icons.camera_alt),
                  //         onPressed: () {},
                  //       ),
                  //     )
                  //   ],
                  // )
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
