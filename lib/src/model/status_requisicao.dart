enum StatusRequisicao { aguardandoAtendimento, emAtendimento, entregue, cancelada }

extension StatusRequisicaoExtension on StatusRequisicao {
  String get descricao {
    switch (this) {
      case StatusRequisicao.aguardandoAtendimento:
        return 'Aguardando Atendimento';
      case StatusRequisicao.emAtendimento:
        return 'Em Atendimento';
      case StatusRequisicao.entregue:
        return 'Entrege';
      case StatusRequisicao.cancelada:
        return 'Cancelada';
      default:
        return '';
    }
  }
}
