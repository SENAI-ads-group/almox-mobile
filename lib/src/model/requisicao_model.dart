import 'package:almox_mobile/src/model/status_requisicao.dart';

class RequisicaoModel {
  final String nomeAlmoxarife;
  final String nomeRequisitante;
  final String dataRequisicao;
  final String departamento;
  final StatusRequisicao statusRequisicao;

  RequisicaoModel(
      {required this.dataRequisicao,
      required this.departamento,
      required this.nomeAlmoxarife,
      required this.nomeRequisitante,
      required this.statusRequisicao});
}
