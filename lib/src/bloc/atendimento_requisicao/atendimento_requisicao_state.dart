import 'package:almox_mobile/src/model/operador_model.dart';
import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:almox_mobile/src/model/status_requisicao.dart';

class AtendimentoRequisicaoState {
  final RequisicaoModel _requisicao;
  final bool _podeSalvar;
  final OperadorModel? operadorLogado;
  final bool carregando;
  final int index;

  AtendimentoRequisicaoState({
    required RequisicaoModel requisicao,
    this.index = 0,
    bool podeSalvar = false,
    this.carregando = false,
    this.operadorLogado,
  })  : _requisicao = requisicao,
        _podeSalvar = podeSalvar;

  RequisicaoModel get requisicao => _requisicao;

  StatusRequisicao get status => _requisicao.status;

  bool get podeSalvar {
    if (StatusRequisicao.AGUARDANDO_ATENDIMENTO == status) {
      return _podeSalvar && operadorLogado?.id == _requisicao.requisitante.id;
    } else {
      return _podeSalvar &&
          status == StatusRequisicao.EM_ATENDIMENTO &&
          operadorLogado?.id == _requisicao.almoxarife.id;
    }
  }

  bool get podeAtender {
    if (StatusRequisicao.AGUARDANDO_ATENDIMENTO != status) {
      return false;
    } else {
      return operadorLogado?.id == _requisicao.almoxarife.id;
    }
  }

  bool get podeCancelar {
    if (StatusRequisicao.AGUARDANDO_ATENDIMENTO == status) {
      return operadorLogado?.id == _requisicao.requisitante.id ||
          operadorLogado?.id == _requisicao.almoxarife.id;
    } else {
      return status == StatusRequisicao.EM_ATENDIMENTO &&
          operadorLogado?.id == _requisicao.almoxarife.id;
    }
  }

  bool get podeEntregar =>
      status == StatusRequisicao.EM_ATENDIMENTO &&
      operadorLogado?.id == _requisicao.almoxarife.id;

  bool get podeEditarItens {
    if (StatusRequisicao.AGUARDANDO_ATENDIMENTO == status) {
      return operadorLogado?.id == _requisicao.requisitante.id;
    } else {
      return status == StatusRequisicao.EM_ATENDIMENTO &&
          operadorLogado?.id == _requisicao.almoxarife.id;
    }
  }

  bool get exibirQrcode {
    if (StatusRequisicao.AGUARDANDO_RECEBIMENTO != status) {
      return false;
    } else {
      return operadorLogado?.id == _requisicao.almoxarife.id;
    }
  }

  bool get existeItemSemQuantidade =>
      _requisicao.itens.isEmpty ||
      _requisicao.itens.any((item) => item.quantidade <= 0);

  AtendimentoRequisicaoState copyWith({
    List<ItemRequisicaoModel>? itens,
    int? index,
    bool? podeSalvar,
    OperadorModel? operadorLogado,
    bool? carregando,
  }) {
    return AtendimentoRequisicaoState(
      requisicao: RequisicaoModel(
        id: _requisicao.id,
        status: _requisicao.status,
        departamento: _requisicao.departamento,
        dataRequisicao: _requisicao.dataRequisicao,
        dataEntrega: _requisicao.dataEntrega,
        requisitante: _requisicao.requisitante,
        almoxarife: _requisicao.almoxarife,
        itens: itens ?? [..._requisicao.itens],
        codigoConfirmacao: _requisicao.codigoConfirmacao,
      ),
      index: index ?? this.index,
      podeSalvar: podeSalvar ?? this.podeSalvar,
      operadorLogado: operadorLogado ?? this.operadorLogado,
      carregando: carregando ?? this.carregando,
    );
  }
}
