import 'package:almox_mobile/src/services/requisicao_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'minhas_requisicoes_event.dart';
import 'minhas_requisicoes_state.dart';

class MinhasRequisicoesBloc
    extends Bloc<MinhasRequisicoesEvent, MinhasRequisicoesState> {
  final RequisicaoService _requisicaoService = RequisicaoService();

  MinhasRequisicoesBloc() : super(MinhasRequisicoesState()) {
    on<CarregarMinhasRequisicoes>(_onCarregarMinhasRequisicoes);
  }

  Future<void> _onCarregarMinhasRequisicoes(
    CarregarMinhasRequisicoes event,
    Emitter<MinhasRequisicoesState> emit,
  ) async {
    emit(state.copyWith(
        status: MinhasRequisicoesStatus.loading, minhasRequisicoes: []));
    try {
      final requisicoes = await _requisicaoService.fetchRequisicoes();
      emit(state.copyWith(
          status: MinhasRequisicoesStatus.success,
          minhasRequisicoes: requisicoes));
    } catch (e) {
      emit(
        state.copyWith(
            status: MinhasRequisicoesStatus.failure, minhasRequisicoes: []),
      );
    }
  }
}
