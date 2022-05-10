import 'package:almox_mobile/src/model/grupo_model.dart';

class ProdutoModel {
  final String id;
  final String descricao;
  final String codigoBarras;
  final String unidadeMedida;
  final GrupoModel grupo;

  ProdutoModel(
      {required this.codigoBarras,
      required this.unidadeMedida,
      required this.id,
      required this.descricao,
      required this.grupo});

  factory ProdutoModel.fromJson(Map<String, dynamic> json) {
    return ProdutoModel(
      id: json['id'],
      descricao: json['descricao'],
      codigoBarras: json['codigoBarras'],
      unidadeMedida: json['unidadeMedida'],
      grupo: GrupoModel.fromJson(json['grupo']),
    );
  }
}
