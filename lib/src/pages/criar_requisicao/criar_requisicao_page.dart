import 'package:almox_mobile/src/model/item_requisicao_model.dart';
import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/widgets/card_produto/botoes_adicionar_remover.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class CriarRequisicaoPage extends StatefulWidget {
  const CriarRequisicaoPage({Key? key}) : super(key: key);

  @override
  State<CriarRequisicaoPage> createState() => _CriarRequisicaoPageState();
}

class _CriarRequisicaoPageState extends State<CriarRequisicaoPage> {
  List<ItemRequisicaoModel> itensSelecionados = [];

  _avisoInformeQuantidades() => AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        headerAnimationLoop: false,
        animType: AnimType.SCALE,
        desc: 'Informe a quantidade dos produtos!',
        showCloseIcon: true,
        btnOkColor: Colors.green,
        btnOkOnPress: () {},
      ).show();

  Future<bool> _onWillPop(BuildContext context) {
    if (itensSelecionados.isNotEmpty) {
      bool existeItemSemQuantidade = itensSelecionados.any((item) => item.quantidade <= 0);

      if (existeItemSemQuantidade) {
        _avisoInformeQuantidades();
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  _pesquisarProdutos(BuildContext context) async {
    List<ProdutoModel>? produtosSelecionadosNaPesquisa = await Navigator.pushNamed(context, '/selecionarProdutos') as List<ProdutoModel>?;

    setState(() {
      itensSelecionados.addAll((produtosSelecionadosNaPesquisa ?? [])
          .where((ProdutoModel produto) => !itensSelecionados.any((i) => i.produto.id == produto.id))
          .map((ProdutoModel produto) => ItemRequisicaoModel(produto: produto, quantidade: 0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    void _decrementarQuantidadeItemRequisicao(int indexItemASerDecrementado) {
      setState(() {
        itensSelecionados.asMap().keys.toList().forEach((index) {
          if (index == indexItemASerDecrementado) {
            ItemRequisicaoModel item = itensSelecionados.elementAt(index);
            if (item.quantidade <= 0) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.QUESTION,
                buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                headerAnimationLoop: false,
                animType: AnimType.SCALE,
                desc: 'Remover Item!',
                showCloseIcon: false,
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                btnOkText: 'Sim',
                btnOkColor: Colors.green,
                btnOkOnPress: () {
                  setState(() {
                    itensSelecionados.removeAt(index);
                  });
                },
                btnCancelText: 'Não',
                btnCancelColor: Colors.red,
                btnCancelOnPress: () {},
              ).show();
            } else {
              item.quantidade = item.quantidade - 1;
            }
          }
        });
      });
    }

    void _incrementarQuantidadeItemRequisicao(int indexItemASerIncrementado) {
      setState(() {
        itensSelecionados.asMap().keys.toList().forEach((index) {
          if (index == indexItemASerIncrementado) {
            ItemRequisicaoModel item = itensSelecionados.elementAt(index);
            item.quantidade = item.quantidade + 1;
          }
        });
      });
    }

    Card _cardItemRequisicao(ItemRequisicaoModel item) {
      int indexItem = itensSelecionados.indexOf(item);
      ItemRequisicaoModel itemRequisicao = itensSelecionados.elementAt(indexItem);
      TextEditingController quantidadeTextFieldController = TextEditingController(text: "${itemRequisicao.quantidade}");
      FocusNode focusNode = FocusNode();
      focusNode.addListener((() {
        if (focusNode.hasFocus) {
          quantidadeTextFieldController.selection = TextSelection(baseOffset: 0, extentOffset: quantidadeTextFieldController.text.length);
        }
      }));

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
        child: ListTile(
          title: Text(item.produto.descricao),
          subtitle: Text(item.produto.grupo.descricao),
          trailing: BotoesAdicionarRemoverProduto(
              quantidadeTextField: TextField(
                focusNode: focusNode,
                controller: quantidadeTextFieldController,
                onSubmitted: (String valor) {
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

    Widget _botoesInclusaoItem() => Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text(
                  'Incluir',
                  style: TextStyle(fontSize: 18),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
                onPressed: () async => await _pesquisarProdutos(context),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
                child: Icon(Icons.camera_alt),
                onPressed: () {},
              ),
            )
          ],
        );

    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
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
                      _botoesInclusaoItem(),
                      Expanded(
                        child: ListView(
                          children: itensSelecionados.map((ItemRequisicaoModel item) => _cardItemRequisicao(item)).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromRGBO(200, 230, 201, 1),
              child: Icon(
                Icons.check,
                color: Color.fromRGBO(37, 96, 41, 1),
              ),
              onPressed: () {
                if (itensSelecionados.isNotEmpty) {
                  bool existeItemSemQuantidade = itensSelecionados.any((item) => item.quantidade <= 0);

                  if (existeItemSemQuantidade) {
                    _avisoInformeQuantidades();
                  } else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                      headerAnimationLoop: false,
                      animType: AnimType.SCALE,
                      desc: 'Requisição criada com sucesso!',
                      showCloseIcon: true,
                      btnOkColor: Colors.green,
                      btnOkOnPress: () {
                        Navigator.pop(context);
                      },
                    ).show();
                  }
                }
              },
            )));
  }
}
