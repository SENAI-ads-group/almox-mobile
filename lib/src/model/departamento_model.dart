class DepartamentoModel {
  final String id;
  final String descricao;
  final Set<_OperadorDepartamento> operadores;

  DepartamentoModel({required this.id, required this.descricao, required this.operadores});

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) {
    return DepartamentoModel(
      id: json['id'],
      descricao: json['descricao'],
      operadores: (json['operaddores'] as List<Map<String, dynamic>>? ?? [])
          .map((opeJson) => opeJson['pessoa'])
          .map(
            (pessoaJson) => _OperadorDepartamento(
              pessoa: _PessoaOperadorDepartamento(
                id: pessoaJson['id'],
                cpf: pessoaJson['cpf'],
                nome: pessoaJson['nome'],
                email: pessoaJson['email'],
              ),
            ),
          )
          .toSet(),
    );
  }
}

class _OperadorDepartamento {
  final _PessoaOperadorDepartamento pessoa;

  _OperadorDepartamento({required this.pessoa});
}

class _PessoaOperadorDepartamento {
  final String id;
  final String cpf;
  final String nome;
  final String email;

  _PessoaOperadorDepartamento({required this.id, required this.cpf, required this.nome, required this.email});
}
