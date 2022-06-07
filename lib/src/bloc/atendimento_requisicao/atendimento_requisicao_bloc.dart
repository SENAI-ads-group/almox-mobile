import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:almox_mobile/src/services/autenticacao_service.dart';
import 'package:almox_mobile/src/services/requisicao_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/produto_model.dart';
import 'atendimento_requisicao_event.dart';
import 'atendimento_requisicao_state.dart';

class AtendimentoRequisicaoBloc
    extends Bloc<AtendimentoRequisicaoEvent, AtendimentoRequisicaoState> {
  final RequisicaoService _requisicaoService = RequisicaoService();
  final AutenticacaoService _autenticacaoService = AutenticacaoService();

  AtendimentoRequisicaoBloc(RequisicaoModel requisicao)
      : super(AtendimentoRequisicaoState(requisicao: requisicao)) {
    on<CarregarAtendimento>(_onCarregarAtendimento);
    on<IniciarAtendimento>(_onIniciarAtendimento);
    on<EntregarRequisicao>(_onEntregarRequisicao);
    on<CancelarRequisicao>(_onCancelarRequisicao);
    on<AtualizarItens>(_onAtualizarItens);

    on<AdicionarProdutos>(_onAdicionarProdutos);
    on<RemoverItem>(_onRemoverItem);
    on<SetIndex>(_onSetIndex);
    on<SetQuantidadeItem>(_onSetQuantidadeItem);
    on<AdicionarQuantidadeItem>(_onAdicionarQuantidadeItem);
    on<RemoverQuantidadeItem>(_onRemoverQuantidadeItem);
  }

  Future<void> _onCarregarAtendimento(
    CarregarAtendimento event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    emit(state.copyWith(carregando: true));
    try {
      final operadorLogado = await _autenticacaoService.operadorLogado;
      emit(state.copyWith(
        podeSalvar: false,
        operadorLogado: operadorLogado,
        carregando: false,
      ));
    } catch (e) {
      emit(state.copyWith(carregando: false));
    }
  }

  Future<void> _onIniciarAtendimento(
    IniciarAtendimento event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    emit(state.copyWith(carregando: true));
    try {
      await _requisicaoService.atenderRequisicao(state.requisicao.id);
      emit(AtendimentoRequisicaoState(
        requisicao:
            await _requisicaoService.fetchRequisicao(state.requisicao.id),
        carregando: false,
        operadorLogado: state.operadorLogado,
      ));
    } catch (e) {
      emit(state.copyWith(carregando: false));
    }
  }

  Future<void> _onEntregarRequisicao(
    EntregarRequisicao event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    emit(state.copyWith(carregando: true));
    try {
      await _requisicaoService.entregarRequisicao(state.requisicao.id);
      emit(
        AtendimentoRequisicaoState(
          requisicao:
              await _requisicaoService.fetchRequisicao(state.requisicao.id),
          carregando: false,
          operadorLogado: state.operadorLogado,
        ),
      );
    } catch (e) {
      emit(state.copyWith(carregando: false));
    }
  }

  Future<void> _onCancelarRequisicao(
    CancelarRequisicao event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    emit(state.copyWith(carregando: true));
    try {
      await _requisicaoService.cancelarRequisicao(state.requisicao.id);
      emit(AtendimentoRequisicaoState(
        requisicao:
            await _requisicaoService.fetchRequisicao(state.requisicao.id),
        operadorLogado: state.operadorLogado,
        carregando: false,
      ));
    } catch (e) {
      emit(state.copyWith(carregando: false));
    }
  }

  Future<void> _onAtualizarItens(
    AtualizarItens event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    emit(state.copyWith(carregando: true));
    try {
      await _requisicaoService.atualizarItens(
          state.requisicao.id, state.requisicao.itens);
      final novaRequisicao =
          await _requisicaoService.fetchRequisicao(state.requisicao.id);
      emit(AtendimentoRequisicaoState(
        requisicao: novaRequisicao,
        operadorLogado: state.operadorLogado,
        carregando: false,
      ));
    } catch (e) {
      emit(state.copyWith(carregando: false));
    }
  }

  Future<void> _onAdicionarProdutos(
    AdicionarProdutos event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    event.produtos
        .where((ProdutoModel produto) =>
            !state.requisicao.itens.any((i) => i.produto.id == produto.id))
        .map(
          (ProdutoModel produto) =>
              ItemRequisicaoModel.fromProdutoModel(produto, 0),
        )
        .forEach(
      (ItemRequisicaoModel item) {
        List<ItemRequisicaoModel> _itens = [...state.requisicao.itens];
        _itens.add(item);
        emit(state.copyWith(
          itens: _itens,
          podeSalvar: true,
        ));
      },
    );
  }

  Future<void> _onRemoverItem(
    RemoverItem event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    List<ItemRequisicaoModel> _itens = [...state.requisicao.itens];
    _itens.removeAt(event.index);
    emit(state.copyWith(
      itens: _itens,
      podeSalvar: true,
    ));
  }

  Future<void> _onSetIndex(
    SetIndex event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    emit(state.copyWith(index: event.index));
  }

  Future<void> _onSetQuantidadeItem(
    SetQuantidadeItem event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    List<ItemRequisicaoModel> _itens = [...state.requisicao.itens];
    final item = _itens.elementAt(event.index);
    item.quantidade += event.valor;
    emit(state.copyWith(
      itens: _itens,
      podeSalvar: true,
    ));
  }

  Future<void> _onAdicionarQuantidadeItem(
    AdicionarQuantidadeItem event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    List<ItemRequisicaoModel> _itens = [...state.requisicao.itens];
    final item = _itens.elementAt(event.index);
    item.quantidade += 1;
    emit(state.copyWith(
      itens: _itens,
      podeSalvar: true,
    ));
  }

  Future<void> _onRemoverQuantidadeItem(
    RemoverQuantidadeItem event,
    Emitter<AtendimentoRequisicaoState> emit,
  ) async {
    List<ItemRequisicaoModel> _itens = [...state.requisicao.itens];
    final item = _itens.elementAt(event.index);
    item.quantidade -= 1;
    emit(state.copyWith(
      itens: _itens,
      podeSalvar: true,
    ));
  }
}
