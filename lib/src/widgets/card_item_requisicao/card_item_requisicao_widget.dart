import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:flutter/material.dart';

import '../card_produto/botoes_adicionar_remover.dart';

class CardItemRequisicao extends StatelessWidget {
  final VoidCallback onRemoverPressed;
  final VoidCallback onAdicionarPressed;
  final ValueChanged<double>? onQuantidadeChanged;

  final int indexItem;
  final ItemRequisicaoModel itemRequisicao;

  const CardItemRequisicao({
    Key? key,
    required this.onRemoverPressed,
    required this.onAdicionarPressed,
    required this.itemRequisicao,
    required this.indexItem,
    this.onQuantidadeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController quantidadeTextFieldController =
        TextEditingController(text: "${itemRequisicao.quantidade}");
    FocusNode focusNode = FocusNode();
    focusNode.addListener(
      (() {
        if (focusNode.hasFocus) {
          quantidadeTextFieldController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: quantidadeTextFieldController.text.length);
        }
      }),
    );

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1))),
      child: ListTile(
        title: Text(itemRequisicao.produto.descricao),
        subtitle: Text(itemRequisicao.produto.grupo.descricao),
        trailing: BotoesAdicionarRemoverProduto(
          quantidadeTextField: TextField(
            focusNode: focusNode,
            controller: quantidadeTextFieldController,
            onSubmitted: (String valor) {
              onQuantidadeChanged!(double.parse(valor));
            },
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          onRemoverPressed: onRemoverPressed,
          onAdicionarPressed: onAdicionarPressed,
        ),
      ),
    );
  }
}
