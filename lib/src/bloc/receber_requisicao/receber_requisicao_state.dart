enum TipoLeitura { camera, input }

class ReceberRequisicaoState {
  ReceberRequisicaoState({
    this.codigo,
    this.carregando = false,
    this.requisicaoConfirmada = false,
    this.erro = false,
    this.tipoLeitura = TipoLeitura.camera,
  });

  final String? codigo;
  final bool carregando;
  final bool requisicaoConfirmada;
  final bool erro;
  final TipoLeitura tipoLeitura;

  ReceberRequisicaoState copyWith({
    required String? codigo,
    bool? carregando,
    bool? requisicaoConfirmada,
    bool? erro,
    TipoLeitura? tipoLeitura,
  }) {
    return ReceberRequisicaoState(
      codigo: codigo,
      carregando: carregando ?? this.carregando,
      requisicaoConfirmada: requisicaoConfirmada ?? this.requisicaoConfirmada,
      erro: erro ?? this.erro,
      tipoLeitura: tipoLeitura ?? this.tipoLeitura,
    );
  }
}
