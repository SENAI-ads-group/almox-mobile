abstract class PessoaModel {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String logradouro;
  final String complemento;
  final String numero;
  final String cep;
  final String cidade;
  final UF uf;
  final String bairro;

  PessoaModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.logradouro,
    required this.complemento,
    required this.numero,
    required this.cep,
    required this.cidade,
    required this.uf,
    required this.bairro,
  });
}

class PessoaFisicaModel extends PessoaModel {
  final String cpf;

  PessoaFisicaModel({
    required String id,
    required String nome,
    required String email,
    required String telefone,
    required String logradouro,
    required String complemento,
    required String numero,
    required String cep,
    required String cidade,
    required UF uf,
    required String bairro,
    required this.cpf,
  }) : super(
          id: id,
          nome: nome,
          email: email,
          telefone: telefone,
          logradouro: logradouro,
          complemento: complemento,
          numero: numero,
          cep: cep,
          cidade: cidade,
          uf: uf,
          bairro: bairro,
        );

  factory PessoaFisicaModel.fromJson(Map<String, dynamic> json) {
    return PessoaFisicaModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      logradouro: json['logradouro'],
      complemento: json['complemento'],
      numero: json['numero'],
      cep: json['cep'],
      cidade: json['cidade'],
      uf: UF.values.firstWhere((uf) => uf.toString() == json['uf'], orElse: () => UF.GO),
      bairro: json['bairro'],
      cpf: json['cpf'],
    );
  }
}

enum UF { AM, AL, AC, AP, BA, PA, MT, MG, MS, GO, MA, RS, TO, PI, SP, RO, RR, PR, CE, PE, SC, PB, RN, ES, RJ, SE, DF }
