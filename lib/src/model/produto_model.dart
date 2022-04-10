import 'package:almox_mobile/src/model/grupo_model.dart';

class ProdutoModel {
  final int id;
  final String descricao;
  final GrupoModel grupo;

  ProdutoModel(
      {required this.id, required this.descricao, required this.grupo});
}
