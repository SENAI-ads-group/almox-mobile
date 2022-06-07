import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/model/requisicao_model.dart';

abstract class AtendimentoRequisicaoEvent {}

class CarregarAtendimento implements AtendimentoRequisicaoEvent {}

class IniciarAtendimento implements AtendimentoRequisicaoEvent {}

class EntregarRequisicao implements AtendimentoRequisicaoEvent {}

class CancelarRequisicao implements AtendimentoRequisicaoEvent {}

class AtualizarItens implements AtendimentoRequisicaoEvent {}

class AdicionarProdutos implements AtendimentoRequisicaoEvent {
  final List<ProdutoModel> produtos;

  AdicionarProdutos(this.produtos);
}

class RemoverItem implements AtendimentoRequisicaoEvent {
  final int index;

  RemoverItem(this.index);
}

class SetIndex implements AtendimentoRequisicaoEvent {
  final int index;

  SetIndex(this.index);
}

class SetQuantidadeItem implements AtendimentoRequisicaoEvent {
  final int index;
  final double valor;

  SetQuantidadeItem(this.index, this.valor);
}

class AdicionarQuantidadeItem implements AtendimentoRequisicaoEvent {
  final int index;

  AdicionarQuantidadeItem(this.index);
}

class RemoverQuantidadeItem implements AtendimentoRequisicaoEvent {
  final int index;

  RemoverQuantidadeItem(this.index);
}
