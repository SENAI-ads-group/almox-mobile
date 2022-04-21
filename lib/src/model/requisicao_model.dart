import 'package:almox_mobile/src/model/status_requisicao.dart';

class RequisicaoModel {
  final String nome_almoxarife;
  final String nome_requisitante;
  final String dataRequisicao;
  final String departamento;
  final StatusRequisicao statusRequisicao;

  RequisicaoModel(
      {required this.dataRequisicao,
      required this.departamento,
      required this.nome_almoxarife,
      required this.nome_requisitante,
      required this.statusRequisicao});
}
