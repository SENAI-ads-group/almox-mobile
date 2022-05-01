import 'package:almox_mobile/src/model/grupo_model.dart';

class ProdutoModel {
  final String id;
  final String descricao;
  final GrupoModel grupo;

  ProdutoModel({required this.id, required this.descricao, required this.grupo});

  factory ProdutoModel.fromJson(Map<String, dynamic> json) {
    return ProdutoModel(
      id: json['id'],
      descricao: json['descricao'],
      grupo: GrupoModel.fromJson(json['grupo']),
    );
  }
}
