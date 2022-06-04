import 'package:almox_mobile/src/bloc/receber_requisicao/receber_requisicao_state.dart';
import 'package:almox_mobile/src/services/requisicao_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceberRequisicaoCubit extends Cubit<ReceberRequisicaoState> {
  final RequisicaoService _requisicaoService = RequisicaoService();

  ReceberRequisicaoCubit() : super(ReceberRequisicaoState());

  setCodigo({String? codigo, bool confirmar = true}) async {
    if (codigo == null) {
      emit(state.copyWith(codigo: null));
    }
    if (!confirmar) {
      emit(state.copyWith(
        codigo: codigo,
        requisicaoConfirmada: false,
      ));
    } else {
      emit(state.copyWith(
        codigo: codigo,
        carregando: true,
        erro: false,
        requisicaoConfirmada: false,
      ));
      try {
        await _requisicaoService.confirmarRecebimentoRequisicao(codigo!);
        emit(state.copyWith(
          codigo: state.codigo,
          carregando: false,
          requisicaoConfirmada: true,
          erro: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          codigo: null,
          carregando: false,
          erro: true,
          requisicaoConfirmada: false,
        ));
      }
    }
  }

  set tipoLeitura(TipoLeitura tipo) {
    emit(state.copyWith(
      codigo: state.codigo,
      tipoLeitura: tipo,
    ));
  }
}
