import 'package:almox_mobile/src/model/produto_model.dart';
import 'package:almox_mobile/src/model/status_requisicao.dart';

class RequisicaoModel {
  final String id;
  final StatusRequisicao status;
  final _DepartamentoRequisicao departamento;
  final DateTime dataRequisicao;
  final DateTime? dataEntrega;
  final _OperadorDaRequisicao requisitante;
  final _OperadorDaRequisicao almoxarife;
  final List<ItemRequisicaoModel> itens;

  RequisicaoModel(
      {required this.id,
      required this.status,
      required this.departamento,
      required this.dataRequisicao,
      this.dataEntrega,
      required this.requisitante,
      required this.almoxarife,
      required this.itens});

  factory RequisicaoModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonItens = json['itens'] as List<dynamic>;

    return RequisicaoModel(
      id: json['id'],
      status: StatusRequisicao.values.firstWhere((status) => status.name == json['status'], orElse: (() => StatusRequisicao.AGUARDANDO_ATENDIMENTO)),
      departamento: _DepartamentoRequisicao.fromJson(json['departamento']),
      dataRequisicao: DateTime.parse(json['dataRequisicao']),
      dataEntrega: json['dataEntrega'] == null ? null : DateTime.parse(json['dataEntrega']),
      requisitante: _OperadorDaRequisicao.fromJson(json['requisitante']),
      almoxarife: _OperadorDaRequisicao.fromJson(json['almoxarife']),
      itens: jsonItens.map((jsonItem) => ItemRequisicaoModel.fromJson(jsonItem)).toList(),
    );
  }
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

  Map toJson() => {
        'idProduto': idProduto,
        'quantidade': quantidade,
      };
}

class _DepartamentoRequisicao {
  final String id;
  final String descricao;

  _DepartamentoRequisicao({
    required this.id,
    required this.descricao,
  });

  factory _DepartamentoRequisicao.fromJson(Map<String, dynamic> json) {
    return _DepartamentoRequisicao(id: json['id'], descricao: json['descricao']);
  }
}

class _OperadorDaRequisicao {
  final String id;
  final _PessoaOperadorDepartamento pessoa;

  _OperadorDaRequisicao({required this.id, required this.pessoa});

  factory _OperadorDaRequisicao.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonPessoa = json['pessoa'];
    return _OperadorDaRequisicao(
      id: json['id'],
      pessoa: _PessoaOperadorDepartamento(id: jsonPessoa['id'], cpf: jsonPessoa['cpf'], nome: jsonPessoa['nome'], email: jsonPessoa['email']),
    );
  }
}

class _PessoaOperadorDepartamento {
  final String id;
  final String cpf;
  final String nome;
  final String email;

  _PessoaOperadorDepartamento({required this.id, required this.cpf, required this.nome, required this.email});
}

class ItemRequisicaoModel {
  final String? id;
  final _ProdutoItem produto;
  num quantidade;

  ItemRequisicaoModel({this.id, required this.produto, required this.quantidade});

  factory ItemRequisicaoModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonProduto = json['produto'];
    Map<String, dynamic> jsonGrupo = jsonProduto['grupo'];
    return ItemRequisicaoModel(
        id: json['id'],
        produto: _ProdutoItem(
            id: jsonProduto['id'],
            descricao: jsonProduto['descricao'],
            codigoBarras: jsonProduto['codigoBarras'],
            unidadeMedida: jsonProduto['unidadeMedida'],
            grupo: _GrupoItem(
              id: jsonGrupo['id'],
              descricao: jsonGrupo['descricao'],
            )),
        quantidade: json['quantidade']);
  }

  factory ItemRequisicaoModel.fromProdutoModel(ProdutoModel produtoModel, num quantidade) {
    return ItemRequisicaoModel(
        produto: _ProdutoItem(
            id: produtoModel.id,
            descricao: produtoModel.descricao,
            codigoBarras: produtoModel.codigoBarras,
            grupo: _GrupoItem(id: produtoModel.grupo.id, descricao: produtoModel.grupo.descricao),
            unidadeMedida: produtoModel.unidadeMedida),
        quantidade: quantidade);
  }
}

class _ProdutoItem {
  final String id;
  final String descricao;
  final String codigoBarras;
  final _GrupoItem grupo;
  final String unidadeMedida;

  _ProdutoItem({required this.id, required this.descricao, required this.codigoBarras, required this.grupo, required this.unidadeMedida});
}

class _GrupoItem {
  final String id;
  final String descricao;

  _GrupoItem({required this.id, required this.descricao});
}
