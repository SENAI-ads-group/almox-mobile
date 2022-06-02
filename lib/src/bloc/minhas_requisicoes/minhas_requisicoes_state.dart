import 'package:almox_mobile/src/model/requisicao_model.dart';

enum MinhasRequisicoesStatus { initial, success, loading, failure }

class MinhasRequisicoesState {
  final List<RequisicaoModel> _minhasRequisicoes;
  final MinhasRequisicoesStatus status;

  MinhasRequisicoesState({
    List<RequisicaoModel> minhasRequisicoes = const [],
    this.status = MinhasRequisicoesStatus.initial,
  }) : _minhasRequisicoes = minhasRequisicoes;

  List<RequisicaoModel> get minhasRequisicoes {
    final requisicoes = [..._minhasRequisicoes];
    requisicoes.sort((a, b) => b.dataRequisicao.compareTo(a.dataRequisicao));
    return requisicoes;
  }

  copyWith({
    List<RequisicaoModel>? minhasRequisicoes,
    MinhasRequisicoesStatus? status,
  }) {
    return MinhasRequisicoesState(
      minhasRequisicoes: minhasRequisicoes ?? this.minhasRequisicoes,
      status: status ?? this.status,
    );
  }
}
