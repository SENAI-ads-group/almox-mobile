enum StatusRequisicao { AGUARDANDO_ATENDIMENTO, EM_ATENDIMENTO, ENTREGUE, CANCELADA }

extension StatusRequisicaoExtension on StatusRequisicao {
  String get descricao {
    switch (this) {
      case StatusRequisicao.AGUARDANDO_ATENDIMENTO:
        return 'Aguardando Atendimento';
      case StatusRequisicao.EM_ATENDIMENTO:
        return 'Em Atendimento';
      case StatusRequisicao.ENTREGUE:
        return 'Entrege';
      case StatusRequisicao.CANCELADA:
        return 'Cancelada';
      default:
        return '';
    }
  }

  String get name {
    return toString().split('.').last;
  }
}
