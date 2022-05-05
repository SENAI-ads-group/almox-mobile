import 'package:almox_mobile/src/model/pessoa_model.dart';

class OperadorModel {
  final String id;
  final PessoaFisicaModel pessoa;

  OperadorModel({required this.id, required this.pessoa});

  factory OperadorModel.fromJson(Map<String, dynamic> json) {
    return OperadorModel(
      id: json['id'],
      pessoa: PessoaFisicaModel.fromJson(json['pessoa'] as Map<String, dynamic>),
    );
  }
}
