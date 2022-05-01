import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/model/produto_model.dart';

class ItemRequisicaoModel {
  int? id;
  final ProdutoModel produto;
  double quantidade;

  ItemRequisicaoModel({required this.produto, this.quantidade = 0});
}
