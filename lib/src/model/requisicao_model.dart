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

class CriarRequisicao {
  final String idOperadorAlmoxarife;
  final String idDepartamento;
  final List<CriarRequisicaoItem> itens;

  CriarRequisicao({required this.idOperadorAlmoxarife, required this.idDepartamento, required this.itens});
}

class CriarRequisicaoItem {
  final String idProduto;
  final num quantidade;

  CriarRequisicaoItem({required this.idProduto, required this.quantidade});
}
